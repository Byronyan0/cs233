# syscall constants
PRINT_STRING            = 4
PRINT_CHAR              = 11
PRINT_INT               = 1

# memory-mapped I/O
VELOCITY                = 0xffff0010
ANGLE                   = 0xffff0014
ANGLE_CONTROL           = 0xffff0018

BOT_X                   = 0xffff0020
BOT_Y                   = 0xffff0024

TIMER                   = 0xffff001c

PRINT_INT_ADDR          = 0xffff0080
PRINT_FLOAT_ADDR        = 0xffff0084
PRINT_HEX_ADDR          = 0xffff0088

ASTEROID_MAP            = 0xffff0050
COLLECT_ASTEROID        = 0xffff00c8

GET_CARGO               = 0xffff00c4

# interrupt constants
BONK_INT_MASK           = 0x1000
BONK_ACK                = 0xffff0060

TIMER_INT_MASK          = 0x8000
TIMER_ACK               = 0xffff006c


.data
# put your data things here
.align 2
asteroid_map: .space 1024

.text
main:
        # put your code here :)
        li        $t5, 10
adj:
        lw        $t1, BOT_X
        bgt	  $t1, 220, done
        li	  $t6, 0		            
	sw	  $t6, ANGLE
	sw	  $t7, ANGLE_CONTROL	            # absolute turn
        li        $t8, 10
        sw        $t8, VELOCITY
        j         adj
done:
        la        $t0, asteroid_map
        sw        $t0, ASTEROID_MAP                # $t0 = map struct 
        add       $t0, $t0, 4                      # $t0 = map array
        li        $t9, 0
        add       $t3, $t0, $t9
        lw        $t3, 0($t3)                      # $t3 = asteroid x and y
        move      $t4, $t3                         
        srl       $t3, $t3, 16                     # $t3 = asteroid x
        and       $t4, $t4, 65535                  # $t4 = asteroid y
        li        $t7, 1                           # absolute turn
align_y:
        lw        $t2, BOT_Y
        sub       $t5, $t2, $t4
        beq       $t2, $t4, align_x
        bgt       $t5, $0, up
        li        $t6, 90
        sw        $t6, ANGLE
        sw        $t7, ANGLE_CONTROL
        li        $t8, 10
        sw        $t8, VELOCITY
        j         align_y
up:
        li        $t6, 270
        sw        $t6, ANGLE
        sw        $t7, ANGLE_CONTROL
        li        $t8, 10
        sw        $t8, VELOCITY
        j         align_y

align_x:
        lw        $t1, BOT_X
        sub       $t5, $t1, $t3
	beq	  $t1, $t3, collect
	bgt	  $t5, $0, left 		    
	li	  $t6, 0		            
	sw	  $t6, ANGLE
	sw	  $t7, ANGLE_CONTROL	            # absolute turn
        li        $t8, 10
        sw        $t8, VELOCITY
	j	  align_x
left:
	li	  $t6, 180			    
	sw	  $t6, ANGLE
	sw	  $t7, ANGLE_CONTROL	            # absolute turn
        li        $t8, 1
        sw        $t8, VELOCITY
	j	  align_x		            

collect:
	li        $t5, 1
        sw        $t5, COLLECT_ASTEROID
        add       $t5, $t5, 1
        add       $t9, $t9, 4
        # note that we infinite loop to avoid stopping the simulation early
        j         main

