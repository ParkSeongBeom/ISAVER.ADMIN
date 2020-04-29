function fnCSController(){
	var objCSController = {};

	objCSController.isCS = false;

	objCSController.init = function(){
		if(typeof vmsBindObj == "object"){
			this.isCS = true;
		} else {
			this.isCS = false;
		}
	};

	objCSController.openVideo = function(notificationId,fenceName,eventDatetime,cancelDatetime,videoFileName){
		if(this.isCS){
			vmsBindObj.openVideo(notificationId,fenceName,eventDatetime,cancelDatetime,videoFileName);
		}
	};

	objCSController.openCamera = function(jsonStr){
		if(this.isCS){
			vmsBindObj.openCamera(JSON.stringify(jsonStr));
		}
	};

	objCSController.isRecording = function(fenceName){
		if(this.isCS){
			return vmsBindObj.isRecording(fenceName);
		}
		return false;
	};
	return objCSController;
}