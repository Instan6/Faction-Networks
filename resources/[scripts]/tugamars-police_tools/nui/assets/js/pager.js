var audio = new Audio('assets/sound/pager_beeps.mp3');
audio.volume=0.3;
var t=null;

function pagerReceived(text){
    let textElem=document.getElementById("text");
    textElem.innerHTML = text;

    let pager=document.getElementById("pager");
    pager.style.display = "block";
    audio.play();

    t=setTimeout(()=>{
        pagerElapssed();
    }, 10000);
}

function pagerElapssed(){
    let pager=document.getElementById("pager");
    pager.style.display = "none";
    audio.pause();
    audio.load();

    if(t !== null) clearTimeout(t);
}