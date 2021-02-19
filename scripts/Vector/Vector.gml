function Vector(_x/*:number*/, _y/*:number*/) constructor {
	x = _x;	/// @is {number}
	y = _y;	/// @is {number}
	
	static add = function(_vector/*:Vector*/)/*->Vector*/ {
		return new Vector(x + _vector.x, y + _vector.y);
	}
	
	static equals = function(_vector/*:Vector*/)/*->bool*/ {
		return (x == _vector.x && y == _vector.y);
	}
}