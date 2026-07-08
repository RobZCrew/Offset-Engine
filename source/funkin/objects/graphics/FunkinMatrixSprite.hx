package funkin.objects.graphics;

import flixel.graphics.frames.FlxFrame;
import flixel.math.FlxMatrix;

// yeah this is copied from flixel one
class FunkinMatrixSprite extends FunkinSprite {
    public final renderMatrix:FlxMatrix;

    public function new(x:Float = 0, y:Float = 0, key:String = '', ?type:SpriteType = NONE) {
        renderMatrix = new FlxMatrix();

        super(x, y, key, type);

        if (FlxG.renderBlit)
            FlxG.log.warn('FunkinMatrixSprites do not work on blit targets');
    }

    override function isSimpleRenderBlit(?cam) {
        return super.isSimpleRenderBlit(cam) && renderMatrix.isIdentity();
    }

    override function prepareComplexMatrix(matrix:FlxMatrix, frame:FlxFrame, camera:FlxCamera) {
        frame.prepareMatrix(matrix, FlxFrameAngle.ANGLE_0, checkFlipX(), checkFlipY());
        matrix.translate(-origin.x, -origin.y);
        matrix.scale(scale.x, scale.y);

        if (bakedRotationAngle <= 0) {
            updateTrig();

            if (angle != 0)
                matrix.rotateWithTrig(_cosAngle, _sinAngle);
        }

        matrix.concat(renderMatrix);

        final screenPos = getScreenPosition(camera).subtract(offset);
        screenPos.add(origin.x, origin.y);
        matrix.translate(screenPos.x, screenPos.y);
        screenPos.put();

        if (isPixelPerfectRender(camera)) {
            matrix.tx = Math.floor(matrix.tx);
            matrix.ty = Math.floor(matrix.ty);
        }
    }
}