class Firebolt extends RB_Thruster;

var SkeletalMeshComponent mSkeletalMesh;

var ParticleSystem mThrustParticleTemplate;
var ParticleSystemComponent mThrustParticle;

var ParticleSystem mExplosionParticleTemplate;

var SoundCue mExplosionSound;

var rotator mStartRotation;
var rotator mTargetRotation;

var float mLifeTimeAfterAttach;

var vector mSpawnLocation;

var float mStartThrustStrength;
var float mTargetThrustStrength;

function FireRocket( vector fireLocation, rotator fireRotation )
{
	SetLocation( fireLocation );
	SetRotation( fireRotation );

	mThrustParticle = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( mThrustParticleTemplate, mSkeletalMesh, 'Effect', true );

	Velocity = Normal( vector( Rotation ) ) * 1000.0f;
	Acceleration = Normal( Velocity ) * 2000.0f;

	mSpawnLocation = Location;

	LifeSpan = 5.0f;
}

simulated event Tick( float delta )
{
	local float alpha;

	super.Tick( delta );

	if( Base != none )
	{
		alpha = 1 - ( LifeSpan / mLifeTimeAfterAttach );
		ThrustStrength = Lerp( mStartThrustStrength, mTargetThrustStrength, alpha );
		SetRotation( RLerp( mStartRotation, mTargetRotation, alpha, true ) );
		mSkeletalMesh.SetRotation( rotator( vector( Rotation ) * -1.0f ) );
	}
}

event HitWall( vector HitNormal, actor Wall, PrimitiveComponent WallComp )
{
	Explode();
}

function Explode()
{
	Destroy();
}

event Destroyed()
{
	TriggerEventClass( class'GGSeqEvent_Explosion', self );
	GGGameInfo( WorldInfo.Game ).OnExplosion( self );
	
	HurtRadius( 100, 500, class'GGDamageTypeExplosiveActor', 50000, Location, GGGoat( Owner ).Controller );
	WorldInfo.MyEmitterPool.SpawnEmitter( mExplosionParticleTemplate, Location );
	PlaySound( mExplosionSound );
}

DefaultProperties
{
	Begin Object class=SkeletalMeshComponent name=RocketMesh
		SkeletalMesh=SkeletalMesh'Bell.Mesh.Firebolt'
	End Object
	mSkeletalMesh=RocketMesh
	Components.Add(RocketMesh)

	Begin Object class=CylinderComponent Name=CollisionCylinder
		CollisionRadius=0
		CollisionHeight=0
	End Object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)

	bCollideActors=true
	bCollideWorld=true

	ThrustStrength=2000

	Physics=PHYS_Projectile

	mThrustParticleTemplate=ParticleSystem'jetPack.Effects.JetThrust'
	mExplosionSound=SoundCue'Bell.Audio.Explosion'

	mExplosionParticleTemplate=ParticleSystem'Goat_Effects.Effects.Effects_Explosion_01'

}
