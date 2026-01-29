/*Select SD Card */

var sdcards={};
var sdcard=null;
var currSelectedPhoto=null;

var cameraAudioPhoto = new Audio('assets/sound/stinger_flash.wav');
cameraAudioPhoto.volume=0.2;

function hideAllUis(){
    $("#camera-lcd-inner > div").hide();
}

function toggleLcd(toggle){
    if(toggle){
        hideAllUis();
        $(".camera-lcd").show();
    }
    if(!toggle) $(".camera-lcd").hide();
}

function setSdCardInfo(info,currSel){
    let str="";
    sdcards={};
    sdcard=null;
    currSelectedPhoto=null;

    let fs=false;

    for(let k in info){
        let i=info[k];
        sdcards[parseInt(i.slot)]=i;

        let c="";
        if(parseInt(i.slot) === parseInt(currSel)){
            c='class="active"';
            fs=true;
        }

        str+='<li '+c+' data-val="'+i.slot+'">'+i.label+' (Slot: '+i.slot+') <span class="float-right">'+i.metadata.photos.length+'/'+i.metadata.maxPhotos+' photos taken</span></li>';
    }

    if(currSel !== null && fs){
        sdcard=sdcards[currSel];
        createPhotos();
    }

    $("#select-sdcard-options").html(str);

    $("#select-sdcard-options > li").on('click', function(e){
        $("#select-sdcard-options > li").removeClass("active");
        $(this).first().addClass("active");
        toggleSdCard(false);

        let val=parseInt($(this).data("val"));
        sdcard=sdcards[val];

        createPhotos();
        togglePhotoviewer(true);

        //Send NUI stuff
        nuiCallback("camera-set-sdcard", {
            sdCardSlot: val
        });
    });
}

function toggleSdCard(toggle){
    if(toggle){
        toggleLcd(true);
        hideAllUis();
        $("#cam-select-sd-card").show();
    }
    if(!toggle) $("#cam-select-sd-card").hide();
}



function togglePhotoviewer(toggle){
    if(toggle){
        toggleLcd(true);
        hideAllUis();
        $("#cam-view-photos").show();
    }
    if(!toggle) $("#cam-view-photos").hide();
}

function toggleSinglePhotoviewer(toggle){
    if(toggle){
        toggleLcd(true);
        hideAllUis();
        $("#cam-view-single-photo").show();
    }
    if(!toggle) $("#cam-view-single-photo").hide();
}

function createPhotos(){
    let photos=sdcard.metadata.photos;
    currSelectedPhoto=null;

    let str="";

    for(let k in photos){
        let photo=photos[k];
        str+='<div class="cam-single-img" data-photo="'+k+'" style="background-image:url(\''+photo.url+'\');">';
        str+='<div class="cam-single-img-tag">#'+(parseInt(k)+1)+'</div>';
        str+='</div>';
    }

    if(photos.length === 0) str="You haven't taken any pictures yet. Click on the viewfinder and take some";

    $("#cam-view-photos").html(str);

    $(".cam-single-img").on('click', function(){
        let photoNum=parseInt($(this).data('photo'));
        generateImageByNum(photoNum);
    });
}

function generateImageByNum(photoNum){

    if(photoNum < 0){
        photoNum=sdcard.metadata.photos.length-1;
    }

    if(photoNum >= sdcard.metadata.photos.length){
        photoNum=0;
    }

    currSelectedPhoto=photoNum;
    let photo=sdcard.metadata.photos[photoNum];
    if(photo !== null){
        hideAllUis();
        $("#cam-view-single-img").attr("src",photo.url);
        let str="";

        str+='<div class="cam-meta-title"><span>Date:</span> '+photo.exif.dateTime+'</div>';
        str+='<div class="cam-meta-title"><span>Zoom:</span> '+(301-Math.round(photo.exif.fov))+'mm analogic</div>';
        str+='<div class="cam-meta-title"><span>Format:</span> '+photo.exif.format+'</div>';

        $("#cam-meta-left").html(str);

        $("#cam-view-url").val(photo.url);

        toggleSinglePhotoviewer(true);
    } else {
        togglePhotoviewer(true);
    }
}

function copyToClipboard(target){
    $("#cam-view-url").select();
    document.execCommand("copy");
}

function deletePhoto(num){
    console.log("Deleting photo: " + num);
    nuiCallback("camera-delete-picture",{photo:num});
}

function goToCamera(){
    //Send some NUI callback
    nuiCallback("camera-take-pictures");
}

function cameraButton(action){
    if(sdcard === null) return false;

    switch(action){
        case "sdcard-menu":
            toggleSdCard(true);
            break;
        case "delete-photo":
            deletePhoto(currSelectedPhoto);
            createPhotos();
            togglePhotoviewer(true);
            break;
        case "view-photos":
            createPhotos();
            togglePhotoviewer(true);
            break;
        case "take-pic":
            goToCamera();
            toggleLcd(false);
            break;
        case "prev-photo":
            generateImageByNum(currSelectedPhoto-1);
            break;
        case "next-photo":
            generateImageByNum(currSelectedPhoto+1);
            break;

    }
}

document.body.addEventListener('keyup', function(e) {
    if (e.key == "Escape" && $(".camera-lcd").is(':visible')) {
        toggleLcd(false);
        nuiCallback("camera-close-menu");
    }
});