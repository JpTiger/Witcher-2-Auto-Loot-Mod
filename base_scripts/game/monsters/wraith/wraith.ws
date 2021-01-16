/***********************************************************************/
/** Witcher Script file
/***********************************************************************/
/** Copyright � 2010
/***********************************************************************/

/////////////////////////////////////////////
// W2MonsterWraith class
/////////////////////////////////////////////

class W2MonsterWraith extends W2Monster
{
	////////////////////////////////////////////////////////////////////////
	// Teleportation
	////////////////////////////////////////////////////////////////////////
	editable var teleportationRangeMin  : float; // >=0			The teleport distance from player
	editable var teleportationRangeMax  : float; // >=0			The teleport distance from player
	editable var retryTeleportationTime : float; // >=0			After teleportation monster will not teleport again for this amount of time
	editable var teleportationChance    : int;   // (0, 100]	The chance (in percentages) that monster will teleport
	editable var teleportDelay			: float; // >=0			The amount of time spent during teleporting

	default teleportationRangeMin  = 6.0;   // meters
	default teleportationRangeMax  = 15.0;   // meters
    default retryTeleportationTime = 9.0;   // seconds
    default teleportationChance    = 40;
    default teleportDelay          = 1;     // seconds

	// Private
	var isTeleporting           : bool;
	var retryTeleportationTimer : float;

	default isTeleporting = false;
	
	////////////////////////////////////////////////////////////////////////
	// Invisibility
	////////////////////////////////////////////////////////////////////////
	editable var invyLowHealthThreshold : float; // (0, 100]	In %. If monster has health below this threshold it will try to make itself invisible.
	editable var invyRetryTime          : float; // >=0			After invisibility mode monster will not enter this stae again for this amount of time.
	editable var invyChance             : int;   // (0, 100]	The chance (in percentages) that monster will turn invisible.
	editable var invyDuration           : float; // >0          In seconds. The amount of time that monster will be invisible.
	
	default invyLowHealthThreshold = 100;
	default invyRetryTime          = 10;
	default invyChance             = 0;
	default invyDuration           = 5;
	
	// Private
	var isInvisibility          : bool;
	var retryInvisibilityTimer  : float;

	default isInvisibility = false;

	////////////////////////////////////////////////////////////////////////
	
	editable var hasLamp : bool;
	
	default hasLamp = false;
	
	var isInitialized : bool;
	
	default isInitialized = false;
	
	////////////////////////////////////////////////////////////////////////

	// Initialize
	function GetMonsterType() : EMonsterType
	{
		return MT_Wraith;
	}
	latent function OnBeforeDestroy()
	{
		if(this.IsAlive())
		{
			EnablePathEngineAgent( false );
			SetAttackableByPlayerRuntime(false, 20.0);
			SetHideInGame(true);
		}
		this.PlayEffect('death_fx');
		this.StopEffect('default_fx');
		Sleep(5.0);
	}
	event OnSpawned(spawnData : SEntitySpawnData )
	{
		var arbitrator : CAIArbitrator = GetArbitrator();
		var goal : CAIGoalMonsterSpawn;	
		var weapon : SItemUniqueId;
		var secondaryWeapon : SItemUniqueId;
		super.OnSpawned(spawnData);
		
		// Teleportation

		GetInventory().AddItem( 'Wraith Teleport', 1 );
		isTeleporting = false;
		retryTeleportationTimer = 0;
		
		// Invisibility
		isInvisibility = false;
		retryInvisibilityTimer = invyRetryTime;
		GetLocalBlackboard().AddEntryFloat( 'inveAttackEnabled', 1.0f );
		
		// Bomb
		GetInventory().AddItem( 'Wraith Bomb', 1 );
		
		isInitialized = true;
		goal = new CAIGoalMonsterSpawn in arbitrator;
		arbitrator.AddGoal( goal, AIP_High );
		this.PlayEffect('default_fx');
		if( hasLamp ) 
			PlayEffect( 'lamp_light' );
		weapon = this.GetInventory().GetItemByCategory('monster_weapon', false);
		secondaryWeapon = this.GetInventory().GetItemByCategory('monster_weapon_secondary', false);
		DrawItemInstant(weapon);
		DrawItemInstant(secondaryWeapon);
	}
	
	function EnterCombat( params : SCombatParams )
	{
		if ( !isTeleporting && !isInvisibility )
		{
			TreeCombatWraith( params );
			OnEnteringCombat();
		}
	}
	
	function StartFogChanneling()
	{
		var goal : CAIGoalWraithFogChanneling;
		var arbitrator : CAIArbitrator = GetArbitrator();
		goal = new CAIGoalWraithFogChanneling in arbitrator;
		arbitrator.AddGoal( goal, AIP_High );
	}
}
state Spawn in W2MonsterWraith extends Base
{
	entry function StateMonsterSpawn( goalId : int )
	{
		var spawnEffect : CEntityTemplate;
		SetGoalId( goalId );
		spawnEffect = (CEntityTemplate)LoadResource("fx\wraith\spawn");
		theGame.CreateEntity(spawnEffect, parent.GetWorldPosition(), parent.GetWorldRotation());
		parent.SetAttackableByPlayerRuntime( false );
		//parent.PlayEffect('spawn_fx');
		parent.WaitForBehaviorNodeDeactivation('SpawnEnd');
		parent.SetSpawnAnim(SA_Idle);
		parent.SetAttackableByPlayerRuntime( true );
		parent.SetImmortalityModeRuntime( AIM_None );
		MarkGoalFinished();
	}
};