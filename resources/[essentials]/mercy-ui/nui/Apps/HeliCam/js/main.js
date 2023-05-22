var HeliCam = RegisterApp('HeliCam');

HeliCam.addNuiListener('SetData', (Data) => {
    $('.helicam-streetname').html(`${Data.Zone} - ${Data.Street}`);
});

HeliCam.addNuiListener('ScanPlate', async (Data) => {
    if (Data.Cancel) {
        $('.helicam-scan').html(`NO LICENSE PLATE SCANNED`);
    } else {
        $('.helicam-scan').html(`PLATE: ${Data.Plate}`);
    }
});