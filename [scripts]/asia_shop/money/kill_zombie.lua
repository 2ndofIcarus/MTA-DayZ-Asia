
addEventHandler( "onZombieGetsKilled", getRootElement(),
    function( killer )
        givePlayerMoney( killer, math.random(0,1) );
    end
)
