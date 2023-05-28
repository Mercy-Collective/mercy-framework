let Wheel = null;
const SegmentsList = [];
const Formatter = new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
});
let segColor = "#000";

function AddSegment(text, segColorOverride = '#000', textFillStyle = '#000') {
    segColor = segColorOverride ? segColorOverride : segColor === '#FFF' ? '#000' : '#FFF';
    SegmentsList.push({ fillStyle: segColor, text, textFillStyle });
}

function CreateWheel() {
    Wheel = new Winwheel({
        numSegments: SegmentsList.length, // Number segments
        outerRadius: 512, // The size of the wheel.
        centerX: 512, // Used to posion on the bckground correctly.
        centerY: 512,
        textFontSize: 28, // Fontze.
        segments: SegmentsList, // Copy the array.
        rotationAngle: ((SegmentsList.length - 2) * (360 / SegmentsList.length)),
        // of the animation
        animation: {
            type: "spinToStop",
            duration: 15,
            spins: 2,
            callbackFinished: () => {},
        },
    });
};

function CalculatePrize(Slot, Duration) {
    if (!Wheel) return console.log("Wheel not found..");
    Wheel.animation.duration = Duration || 15;
    const IDx = (Slot * (360 / SegmentsList.length));
    const StopAt = IDx + ((360 / SegmentsList.length) / 2) + 1;
    Wheel.rotationAngle = 0;
    Wheel.animation.stopAngle = StopAt;
    Wheel.animation.spins = Math.floor(Math.random() * (4 - 2 + 1) + 2);
    Wheel.startAnimation();
};

window.addEventListener("DOMContentLoaded", (Event) => {
    gsap.registerPlugin();
});

window.addEventListener("message", function (Event) {
    let Data = Event.data;
    let Action = Data.Action;
    if (Action == 'CreateWheel') {
        // Create Segments
        for (let SlotId = 0; SlotId < Data.Slots.length; SlotId++) {
            const Slot = Data.Slots[SlotId];
            if (SlotId == Data.Slots.length - 1) { // Last Slot = Car
                AddSegment(Slot['Model'].toUpperCase(), Slot['Colour']);
            } else if (SlotId % 2 === 0) { // Even
                AddSegment(Formatter.format(Slot['Amount']), Slot['Colour'], "#000");
            } else if (SlotId % 2 !== 0) { // Odd
                AddSegment(Formatter.format(Slot['Amount']), Slot['Colour']);
            }
        }
        // Create Wheel
        CreateWheel();
    } else if (Action == 'DoWheel') {
        CalculatePrize(Data.Slot, Data.Speed);
    }
});