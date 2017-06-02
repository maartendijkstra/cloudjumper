import flash.filters.*;

jumping=true;
highJumping = highJump = dood = playGame = false;
grondY = 405;
velY = falling = clouds = rocks = tempHeight = curHeight = maxHeight = score = 0;
cloudsY = rocksY = 400;
var filter:DropShadowFilter = new DropShadowFilter(2, 90, 0x999999, 0.8, 5, 5, 1, 3, false, false, false);
var filterArray:Array = new Array();
filterArray.push(filter);

dir=false;

init();
var showHelp = setInterval(showHelpText, 5000);
var hideHelp = setInterval(hideHelpText, 10000);

_root.onEnterFrame = function() {
	_root.onMouseDown = function(){
			if(!highJumping && !jumping && !dood){
				velY = 18;
				jumping = true;
				hideHelpText();
				clearInterval(showHelp);
				clearInterval(hideHelp);
			}
		}
		
		if(!dood){
			Mouse.hide();
			cursor._x = _root._xmouse	;
			cursor._y = _root._ymouse	;
			mx = _root._xmouse;
				
			followMouse(mx);
		}
		
		tempHeight += velY;
		if(tempHeight > curHeight) curHeight = tempHeight;
		if(curHeight > maxHeight) { maxHeight = curHeight; highScore = true; } 
		heightText.text = Math.round(curHeight/100) + " m";
		scoreText.text = score;
		
		if(velY < 0) {falling++;} else {falling=0;} 
		
		if (jumping) {
			if(velY > 5) {
				_root.player.gotoAndStop(5);
			} else {
				_root.player.gotoAndStop(1);
			}
			
			_root.player._y -= --velY;
			
			if (_root.player._y>=grondY) {
				if(highJump) _root.player._y = grondY;
				if(dood){
					_root.crater._x = _root.player._x;
					_root.crater._y = _root.player._y+10;
					_root.player._x = -200;
					_root.crater.play();
				}
				jumping = false;
				velY = 0;
			}
		}	
		
		if (highJumping) {
			if(velY > 5) {
				_root.player.gotoAndPlay(5);
			} else {
				_root.player.gotoAndStop(1);
			}
			
			_root.grond._y += velY;
			for(i=1;i<=clouds;i+=1){
				_root["rots"+i]._y += velY;
				_root["berry"+i]._y += velY;
				_root["wolk"+i]._y += velY/3;
			}
			velY--;
			if(_root.grond._y < 400 || falling > 75) {
				dood = true;
				_root.grond._y = 400;
				jumping = true;
				highJumping = false;
				showStats();
			}
		}
	}

function init() {
	for(i = 1; i < 6;i+=1){
		addCloud("wolk" + i, cloudsY-(i*100));
		addBerry("berry" + i, cloudsY-(i*200));
	}
	
	for(i = 1; i < 4;i+=1){
		addRock("rots" + i, rocksY-(i*100));
		rocksY-=100;
	}
}

function hideHelpText(){

	_root.helpText.onEnterFrame = function() {
		if(this._alpha > 0){
		this._alpha -= 5;
		}
	}
	clearInterval(hideHelp);
}

function showHelpText(){
	_root.helpText.onEnterFrame = function() {
		if(this._alpha < 100){
		this._alpha += 5;
		}
	}
	clearInterval(showHelp);
}

function followMouse(mx){
	if (mx<_root.player._x) {
		_root.player._xscale = 80;
		_root.player._rotation = -(velY/2)*-1;
		dx = _root.player._x-mx;
	} else {
		_root.player._xscale = -80;
		_root.player._rotation = (velY/2)*-1;
		dx = mx-_root.player._x;
	}
	moveSpeedx = dx/10;
	if (mx<_root.player._x) {
		_root.player._x -= moveSpeedx;
	} else {
		_root.player._x += moveSpeedx;
	}
}

function showStats(){
	Mouse.show();
	cursor._x = -40;
	cursor._y = 50;
	for(i = 1; i < 5;i+=1){
		removeMovieClip(eval("rots" + i));
	}
	for(i = 1; i < 6;i+=1){
		removeMovieClip(eval("berry" + i));
	}
	_root.statBG.altitude.text = Math.round(curHeight/100);
	_root.statBG.berries.text = score;
	_root.statBG._x = Stage.width/2;
	_root.statBG._y = ((Stage.height/2)-50);
	_root.statBG.retry_btn.onRelease = function(){ restart(); }
}

function restart(){
	cloudsY = rocksY = 400;
	curHeight = tempHeight = score = 0;
	dood = false;
	rocks = 0;
	jumping = false;
	_root.statBG._x = -500;
	_root.player._rotation = 0;
	_root.player._x = _root._xmouse;
	_root.player._y = grondY;
	_root.crater._x = -900;
	for(i = 1; i < 4;i+=1){
		addRock("rots" + i, rocksY-(i*100));
		rocksY-=100;
	}
	for(i = 1; i < 6;i+=1){
		addBerry("berry" + i, cloudsY-(i*200));
	}
}


function addRock(naam, Y){
	//trace("addRock" + naam + " -> " + Y);
	var blaat =  _root.rots.duplicateMovieClip(naam, _root.getNextHighestDepth());
	_root.player.swapDepths(_root.getNextHighestDepth());
	varX = (Math.random()*500);
	varY = Y;
	blaat._x = varX;
	if(varX > Stage.width/2) { blaat._xscale = -blaat._xscale; }
	blaat._y = varY;
	blaat.filters = filterArray;
	blaat._name = naam;
	blaat.onEnterFrame = function(){
		//trace((this._y+10) + "/" + Math.round(player._y-player._height));
		if(this.hitTest(_root.player.poot) && this._y+10 > player._y && velY < -5){
			_root.highJumping = true;
			_root.highJump = true;
			_root.jumping = false;
			_root.velY = 23;
			_root.player.play();
			_root.addRock(this._name, -40);
			this.play();
		}
		else if(this._y > Stage.height + (400 - (Math.random()*50))){
			_root.addRock(this._name, -40);
			removeMovieClip(this);
		}
	}
}

function addCloud(naam, Y){
	var blaat = _root.wolk.duplicateMovieClip(naam, _root.getNextHighestDepth());
		varX = (Math.random()*500);
		varY = Y;
		blaat._x = varX;
		blaat._y = varY;
		blaat._name = naam;
		blaat._alpha = 30;
		clouds++;
		cloudsY-=200;
		blaat.onEnterFrame = function(){
			if(this._y > Stage.height + 600 + (Math.random()*100)){
				this._y -= (Stage.height + 700);
				this._x = (Math.random()*500);
			}
		}
}

function addBerry(naam, Y){
	var blaat = _root.berries.duplicateMovieClip(naam, _root.getNextHighestDepth());
		varX = (Math.random()*500);
		varY = Y;
		blaat._x = varX;
		blaat._y = varY;
		blaat._name = naam;
		clouds++;
		berriesY-=200;
		blaat.onEnterFrame = function(){
			if(this.hitTest(_root.player)){
				_root.addBerry(this._name, -(Stage.height + 700));
				showScore(10, this._x, this._y);
				removeMovieClip(this);
				score += 3;
			}
			if(this._y > Stage.height + 600 + (Math.random()*100)){
				this._y -= (Stage.height + 700);
				this._x = (Math.random()*500);
			}
		}
}

function showScore(score, x, y) {
	var blaat = _root.scoreShow.duplicateMovieClip("showScore1", _root.getNextHighestDepth());
	blaat._x = x;
	blaat._y = y;
	blaat.onEnterFrame = function(){
		this._xscale+=10;
		this._yscale+=10;
		this._alpha -=5;
		this._y -= 5;
		if(this._xscale > 350){
			removeMovieClip(this);
		}
	}
}