var BoardId=null;
function getParameters(){
    const queryString = window.location.search;
    return new URLSearchParams(queryString);
}

function loadBoardDisplay(board){
    let dataUrl=board.canvas;
    $(".board-images").html("");
    $(".canvas-board").css('background-image','url("'+dataUrl+'")');

    let imgs=board.images;
    for(let k in imgs){
        let img=imgs[k];
        if(img === null) continue;

        let elem=document.createElement('img');
        elem.src=img.img;
        elem.classList.add('draggable');

        $(elem).css({
            height: img.size.height,
            top: img.position.y+"px",
            left: img.position.x+"px",
        });
        $(".board-images").append(elem);
    }
}

$(document).ready(()=>{
    const params=getParameters();
    BoardId=params.get("id");

    $("#cenas").text("Board ID: " + BoardId);

    nuiCallback("getBoard",{board:{id:BoardId}}).then( (response) => {
        loadBoardDisplay(response.data);
    });
});

