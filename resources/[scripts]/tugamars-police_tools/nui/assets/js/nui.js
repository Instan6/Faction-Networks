
window.addEventListener('message', (event) => {

    if(event.data.debug){
        console.log("[Debug] Debug enabled!");
        console.log(event);
    }

    if (event.data.action === 'camera-overlay-show') {
        $(".camera-ui").show();
    } else if(event.data.action === 'camera-overlay-hide'){
        $(".camera-ui").hide();
    } else if(event.data.action === 'camera-menu-show'){
        setSdCardInfo(event.data.sdcards);
        toggleLcd(true);
        toggleSdCard(true);
    } else if(event.data.action === 'camera-menu-toggle'){
        if($("#cam-select-sd-card").is(":visible")){
            toggleLcd(false);
            toggleSdCard(false);
        }
        else {
            setSdCardInfo(event.data.sdcards, event.data.currSel);
            toggleLcd(true);
            toggleSdCard(true);
        }
    } else if(event.data.action === 'camera-update-sdcard'){
        setSdCardInfo(event.data.sdcards, event.data.currSel);
    } else if(event.data.action === 'camera-take-picture'){
        cameraAudioPhoto.play();
    } else if(event.data.action === 'tintmeter-open'){
        tintMeterOpen();
    } else if(event.data.action === 'pagerReceived') {
        if(event.data.debug){
            console.log("[Pager] Pager received!");
        }
        pagerReceived(event.data.text);
    } else if(event.data.action === 'pagerElapssed'){
        pagerElapssed();
    }
});

function nuiCallback(url, body){

    return fetch(`https://${GetParentResourceName()}/${url}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify(body)
    }).then(resp => resp.json());
}