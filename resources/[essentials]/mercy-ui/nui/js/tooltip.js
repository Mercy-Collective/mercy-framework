(function($) {

    function maybeCall(thing, ctx) {
        return (typeof thing == 'function') ? (thing.call(ctx)) : thing
    }

    function Hint(element, options) {
        this.$element = $(element)
        this.options = options
        this.enabled = true
        this.fixTitle()
    }

    Hint.prototype = {
        show: function() {
            $('.tooltip-css').remove()
            var title = this.getTitle()
            if (title && this.enabled) {
                var $tip = this.tip()

                $tip.find('.tooltip-css-inner')[this.options.html ? 'html' : 'text'](title)[this.options.html ? 'addClass' : 'removeClass']('tooltip-css-inner-html')
                    .css({
                        'text-align': this.options.textAlign
                    })

                $tip[0].className = 'tooltip-css' // reset classname in case of dynamic gravity
                $tip.remove().css({
                    top: 0,
                    left: 0,
                    visibility: 'hidden',
                    display: 'block'
                }).prependTo(document.body)

                if (this.options.className) {
                    $tip.addClass(maybeCall(this.options.className, this.$element[0]))
                }

                if (this.options.fade) {
                    $tip.stop().css({
                        opacity: 0,
                        display: 'block',
                        visibility: 'visible'
                    }).animate({
                        opacity: this.options.opacity
                    }, this.options.fadeTime)
                } else {
                    $tip.css({
                        visibility: 'visible',
                        opacity: this.options.opacity
                    })
                }
                this.calculatePosition()
                this._checkStatus()
            }
        },

        update: function(title) {
            var $tip = this.tip()
            if ($tip && title && this.enabled) {

                $tip.find('.tooltip-css-inner')[this.options.html ? 'html' : 'text'](title)
            }
        },

        calculatePosition: function() {
            var $tip = this.tip()
            var pos = $.extend({}, this.$element.offset(), {
                width: this.$element[0].offsetWidth,
                height: this.$element[0].offsetHeight
            })

            var actualWidth = $tip[0].offsetWidth,
                actualHeight = $tip[0].offsetHeight,
                gravity = maybeCall(this.options.gravity, this.$element[0])

            var tp
            switch (gravity.charAt(0)) {
                case 'n':
                    tp = {
                        top: pos.top + pos.height + this.options.offset,
                        left: pos.left + pos.width / 2 - actualWidth / 2
                    }
                    break
                case 's':
                    tp = {
                        top: pos.top - actualHeight - this.options.offset,
                        left: pos.left + pos.width / 2 - actualWidth / 2
                    }
                    break
                case 'e':
                    tp = {
                        top: pos.top + pos.height / 2 - actualHeight / 2,
                        left: pos.left - actualWidth - this.options.offset
                    }
                    break
                case 'w':
                    tp = {
                        top: pos.top + pos.height / 2 - actualHeight / 2,
                        left: pos.left + pos.width + this.options.offset
                    }
                    break
            }

            if (gravity.length == 2) {
                if (gravity.charAt(1) == 'w') {
                    tp.left = pos.left + pos.width / 2 - 15
                } else {
                    tp.left = pos.left + pos.width / 2 - actualWidth + 15
                }
            }

            if (gravity === 'n' && tp.top + actualHeight > $(window).height()) {
                gravity = 's'
                tp.top = pos.top - actualHeight - this.options.offset
            }

            if (tp.left < 0 || tp.top < 0) {
                tp.left = -1000
                tp.top = -1000
            }

            $tip.css(tp)
            $tip.addClass('tooltip-css-' + gravity)
            $tip.find('.tooltip-css-arrow')[0].className = 'tooltip-css-arrow tooltip-css-arrow-' + gravity.charAt(0)
        },

        hide: function() {
            if (this.options.fade) {
                this.tip().stop().fadeOut(this.options.fadeTime, function() {
                    $(this).remove()
                })
            } else {
                this.tip().remove()
            }
            window.clearInterval(this._checkingInterval)
        },

        fixTitle: function() {
            var $e = this.$element
            if ($e.attr('title') && !$e.attr('data-tooltip')) {
                $e.attr('data-tooltip', $e.attr('title') || '').removeAttr('title')
            }
        },

        getTitle: function() {
            var title, $e = this.$element, o = this.options
            this.fixTitle()
            if (typeof o.title == 'string') {
                title = $e.attr(o.title == 'title' ? 'data-tooltip' : o.title)
            } else if (typeof o.title == 'function') {
                title = o.title.call($e[0])
            }
            title = ('' + title).replace(/(^\s*|\s*$)/, "")
            return title || o.fallback
        },

        tip: function() {
            if (!this.$tip) {
                this.$tip = $('<div class="tooltip-css"></div>').html('<div class="tooltip-css-arrow"></div><div class="tooltip-css-inner"></div>')
                this.$tip.data('tooltip-pointee', this.$element[0])
            }
            return this.$tip
        },

        _checkStatus: function() {
            if (this._checkingInterval) {
                window.clearInterval(this._checkingInterval)
            }
            var that = this
            this._checkingInterval = window.setInterval(function() {
                if (!that.$element || that.$element.is(':hidden')) {
                    that.hide()
                }
            }, 300)
        }
    }

    // global listen
    $.hint = function() {
        var get = function(ele, options) {
            var hint = ele.data('tooltip-css')
            var keyAndValue = ele.data('tooltip-object')
            options.html = !!ele.data('tooltip-html')
            options.textAlign = ele.data('tooltip-align') || $.hint.defaults.textAlign
            options.maxWidth = ele.data('tooltip-max-width') || 0
            if (!hint) {
                if (keyAndValue && typeof keyAndValue === 'object') {
                    hint = new Hint(ele, $.extend({}, $.hint.defaults, options, {
                        className: 'tooltip-object',
                        html: true,
                        title: function() {
                            try {
                                keyAndValue = JSON.parse(ele.attr('data-tooltip-object'))
                            } catch (e) {
                                // to nothing
                            }
                            return $('<div>').append($.dialog.getKeyAndValTable(keyAndValue, 2)).html()
                        }
                    }))
                } else {
                    hint = new Hint(ele, $.extend({}, $.hint.defaults, options))

                }
                ele.data('tooltip-css', hint)
            }
            return hint
        },

        getGravity = function($e) {
            if ($e.data('gravity')) {
                return $e.data('gravity')
            }

            switch ($e.attr("data-position")) {
                case 'top':
                    return 's';
                case 'bottom':
                    return 'n';
                case 'left':
                    return 'e';
                case 'right':
                    return 'w';
                default:
                    return $.hint.defaults.gravity;
            };
        }

        var timer = 0
        $(document).on('mouseenter', '[data-tooltip]', function(e) {
            if ($(this).data('tooltip-type') === 'ignore') {
                return
            }
            if (
                $(this).attr('tooltip-auto') !== undefined &&
                $(this)[0].offsetWidth >= $(this)[0].scrollWidth
            ) {
                return
            }
            if (e.stopPropagation) {
                e.stopPropagation()
            }
            timer = setTimeout(function() {
                var $e = $(e.currentTarget)
                var hint = get($e, {
                    gravity: getGravity($e)
                })
                hint.hoverState = 'in'
                hint.show()
            }, $.hint.defaults.delayIn)
        })
        $(document).on('mouseleave', '[data-tooltip]', function(e) {
            if ($(this).data('tooltip-type') === 'ignore') {
                return
            }
            clearTimeout(timer)
            var $e = $(e.currentTarget)
            var hint = get($e, {
                gravity: getGravity($e)
            })
            hint.hoverState = 'out'
            hint.hide()
        })
        $(document).on('click', '[data-tooltip]', function(e) {
            clearTimeout(timer)
        })
    }

    $.fn.hint = function(method, params) {
        var $e = this
        var hint = $('body').data('tooltip-css')
        $e.data('tooltip-type', 'ignore')
        switch (method) {
            case 'show':
                hint = new Hint($e, $.extend({}, $.hint.defaults, {
                    gravity: 'n',
                    className: 'tooltip-object',
                    html: true,
                    title: function() {
                        return $('<div>').append($.dialog.getKeyAndValTable(params, 2)).html()
                    }
                }))
                hint.hoverState = 'in'
                hint.show()
                $('body').data('tooltip-css', hint)
                break
            case 'update':
                hint.update($('<div>').append($.dialog.getKeyAndValTable(params, 2)).html())
                break
            case 'hide':
                hint.hoverState = 'out'
                hint.hide()
                break
        }
    }

    $.hint.defaults = {
        className: null,
        delayIn: 0,
        fade: true,
        fadeTime: 150,
        fallback: 'No Tooltip ):',
        gravity: 's',
        html: false, //data-tooltip-html="true|false"
        live: false,
        offset: 5,
        opacity: 1.0,
        title: 'title',
        textAlign: 'center', //data-tooltip-align="center"
        maxWidth: 0 // data-tooltip-max-width 1886537
    }

})(jQuery)

$(function() {
    $.hint()
})