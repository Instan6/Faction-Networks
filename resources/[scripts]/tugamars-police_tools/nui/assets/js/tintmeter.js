function tintMeterOpen(){
    setTintText("---");
    $(".tintmeter-ui").show();
}

function tintMeterClose(){
    $(".tintmeter-ui").hide();
    nuiCallback("tintmeter:close");
}

function setTintText(value){
    if( typeof value === 'number') value=parseFloat(parseFloat(value).toFixed(1));
    $("#tintmeter-text").text(value);
}

function startTintCheck(){
    const resp=nuiCallback("tintmeter:start");
    resp.then(json => {
       setTintText(json.value);
    });
}

document.body.addEventListener('keyup', function(e) {
    if (e.key == "Escape" && $(".tintmeter-ui").is(':visible')) {
        tintMeterClose();
    }
});