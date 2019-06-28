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

	objCSController.openVideo = function(notificationId){
		if(this.isCS){
			vmsBindObj.openVideo(notificationId);
		}
	};
	return objCSController;
}