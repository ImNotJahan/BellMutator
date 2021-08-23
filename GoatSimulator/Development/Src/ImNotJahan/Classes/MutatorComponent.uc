class MutatorComponent extends GGMutatorComponent;

var Material mBellMaterial;

var SkeletalMeshComponent mRocketPackMesh;

var Firebolt mRockets;
var SkeletalMeshComponent mDeadMau5Mesh;

function AttachToPlayer( GGGoat goat, optional GGMutator owningMutator )
{
	super.AttachToPlayer(goat, owningMutator);
	
	if(mGoat != none)
	{
		mGoat.mesh.SetMaterial(0, mBellMaterial);
	}
	
	if(GGPlayerControllerGame( goat.Controller ) != none)
	{
		GGPlayerControllerGame( goat.Controller ).Pawn.mesh.AttachComponentToSocket( mDeadMau5Mesh, 'hairSocket' );
	}
}

function KeyState( name newKey, EKeyState keyState, PlayerController PCOwner )
{
	local GGPlayerInputGame localInput;
	
	local vector fireLocation;

	if(PCOwner != mGoat.Controller)
		return;

	localInput = GGPlayerInputGame( PlayerController( mGoat.Controller ).PlayerInput );

	if(keyState == KS_Up)
	{
		if(localInput.IsKeyIsPressed("GBA_Special", string(newKey)))
		{
			mRockets = mGoat.Spawn( class'Firebolt' );
			mRocketPackMesh.AttachComponentToSocket( mRockets.mSkeletalMesh, 'Fire_01' );
			
			mRocketPackMesh.DetachComponent( mRockets.mSkeletalMesh );
			mRockets.AttachComponent( mRockets.mSkeletalMesh );

			mRocketPackMesh.GetSocketWorldLocationAndRotation('Fire_01', fireLocation );

			mRockets.FireRocket( fireLocation, mGoat.Rotation );
			mRockets = none;
		}
	}
}

DefaultProperties
{
	Begin Object class=SkeletalMeshComponent Name=rocketPack
		SkeletalMesh=SkeletalMesh'Heist_AttachableRockets.mesh.RocketPack'
	End Object
	mRocketPackMesh=rocketPack
	
	Begin Object class=SkeletalMeshComponent Name=StaticMeshComp1
		SkeletalMesh=SkeletalMesh'Bell.Mesh.BunnyEars'
	End Object
	mDeadMau5Mesh=StaticMeshComp1
	
	mBellMaterial=Material'Bell.Materials.Skin'
}