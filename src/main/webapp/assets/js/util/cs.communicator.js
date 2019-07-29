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

	objCSController.openVideo = function(notificationId,fenceId,eventDatetime,cancelDatetime){
		if(this.isCS){
			vmsBindObj.openVideo(notificationId,fenceId,eventDatetime,cancelDatetime);
		}
	};

	objCSController.isRecording = function(fenceId){
		if(this.isCS){
			return vmsBindObj.isRecording(fenceId);
		}
		return false;
	};
	return objCSController;
}