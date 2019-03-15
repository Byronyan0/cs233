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

STATION_LOC             = 0xffff0054
DROPOFF_ASTEROIDS       = 0xffff005c

GET_CARGO               = 0xffff00c4

# interrupt constants
BONK_INT_MASK           = 0x1000
BONK_ACK                = 0xffff0060

TIMER_INT_MASK          = 0x8000
TIMER_ACK               = 0xffff006c

STATION_ENTER_INT_MASK  = 0x400
STATION_ENTER_ACK       = 0xffff0058

STATION_EXIT_INT_MASK   = 0x2000
STATION_EXIT_ACK        = 0xffff0064


.data
# put your data things here
.align 2
asteroid_map: .space 1024
station_in: .space 1


.text
main:
        li	  $t4, STATION_ENTER_INT_MASK		
        or        $t4, STATION_EXIT_INT_MASK
	or	  $t4, $t4, 1		# global interrupt enable
	mtc0	  $t4, $12		# set interrupt mask (Status register)
        la        $t0, station_in
        lb        $t0, 0($t0)
        bne       $t0, 0, store
stored:
        li        $t5, 10
adj:
        lw        $t1, BOT_X
        bgt	  $t1, 220, dones
        li	  $t6, 0		            
	sw	  $t6, ANGLE
	sw	  $t7, ANGLE_CONTROL	            # absolute turn
        li        $t8, 10
        sw        $t8, VELOCITY
        j         adj
dones:
        la        $t0, asteroid_map
        sw        $t0, ASTEROID_MAP                # $t0 = map struct                       
        add       $t0, $t0, 4                      # $t0 = map array
        lw        $t3, 0($t0)                      # $t3 = asteroid x and y
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
	li	  $t6, 180			    # set orientation to south
	sw	  $t6, ANGLE
	sw	  $t7, ANGLE_CONTROL	            # absolute turn
        li        $t8, 1
        sw        $t8, VELOCITY
	j	  align_x		            # keep adjust y

collect:
	li        $t5, 1
        sw        $t5, COLLECT_ASTEROID
        add       $t5, $t5, 1
        add       $t9, $t9, 4
        # note that we infinite loop to avoid stopping the simulation early
        j         main

store:
        li        $t5, 10
adjd:
        lw        $t1, BOT_X
        bgt	  $t1, 220, doned
        li	  $t6, 0		            
	sw	  $t6, ANGLE
	sw	  $t7, ANGLE_CONTROL	            # absolute turn
        li        $t8, 10
        sw        $t8, VELOCITY
        j         adjd
doned:
align_yd:
        lw        $t0, STATION_LOC                    
        move      $t4, $t0                         
        srl       $t3, $t0, 16                     # $t3 = station x
        and       $t4, $t4, 65535                  # $t4 = station y

        lw        $t2, BOT_Y
        sub       $t5, $t2, $t4
        beq       $t2, $t4, align_xd
        bgt       $t5, $0, upd
        li        $t6, 90
        sw        $t6, ANGLE
        sw        $t7, ANGLE_CONTROL
        li        $t8, 10
        sw        $t8, VELOCITY
        j         align_yd
upd:
        li        $t6, 270
        sw        $t6, ANGLE
        sw        $t7, ANGLE_CONTROL
        li        $t8, 10
        sw        $t8, VELOCITY
        j         align_yd

align_xd:
        lw        $t0, STATION_LOC                    
        move      $t4, $t0                         
        srl       $t3, $t0, 16                     # $t3 = station x
        and       $t4, $t4, 65535                  # $t4 = station y

        lw        $t1, BOT_X
        sub       $t5, $t1, $t3
	beq	  $t1, $t3, drop
	bgt	  $t5, $0, leftd 		    
	li	  $t6, 0		            
	sw	  $t6, ANGLE
	sw	  $t7, ANGLE_CONTROL
        li        $t8, 10
        sw        $t8, VELOCITY
	j	  align_xd
leftd:
	li	  $t6, 180
	sw	  $t6, ANGLE
	sw	  $t7, ANGLE_CONTROL
        li        $t8, 1
        sw        $t8, VELOCITY
	j	  align_xd
drop:
        sw        $t5, DROPOFF_ASTEROIDS
        j         stored



.kdata				# interrupt handler data (separated just for readability)
chunkIH:	.space 8	# space for two registers
non_intrpt_str:	.asciiz "Non-interrupt exception\n"
unhandled_str:	.asciiz "Unhandled interrupt type\n"


.ktext 0x80000180
interrupt_handler:
.set noat
	move	$k1, $at		# Save $at                               
.set at
	la	$k0, chunkIH
	sw	$a0, 0($k0)		# Get some free registers                  
	sw	$a1, 4($k0)		# by storing them to a global variable     

	mfc0	$k0, $13		# Get Cause register                       
	srl	$a0, $k0, 2                
	and	$a0, $a0, 0xf		# ExcCode field                            
	bne	$a0, 0, non_intrpt         

interrupt_dispatch:			# Interrupt:                             
	mfc0	$k0, $13		# Get Cause register, again                 
	beq	$k0, 0, done		# handled all outstanding interrupts     

	and	$a0, $k0, BONK_INT_MASK 	# is there a bonk interrupt?                
	bne	$a0, 0, bonk_interrupt

	and	$a0, $k0, STATION_ENTER_INT_MASK	# is there a station interrupt?
	bne	$a0, 0, stationin_interrupt

        and	$a0, $k0, STATION_EXIT_INT_MASK	# is there a station interrupt?
	bne	$a0, 0, stationex_interrupt
	# add dispatch for other interrupt types here.

	li	$v0, PRINT_STRING	# Unhandled interrupt types
	la	$a0, unhandled_str
	syscall 
	j	done

bonk_interrupt:
        sw      $a1, BONK_ACK   # acknowledge interrupt

        li      $a1, 10                  #  ??
        lw      $a0, 0xffff001c($zero)   # what
        and     $a0, $a0, 1              # does
        bne     $a0, $zero, bonk_skip    # this 
        li      $a1, -10                 # code
bonk_skip:                               #  do 
        sw      $a1, 0xffff0010($zero)   #  ??  

        j       interrupt_dispatch       # see if other interrupts are waiting
      
stationin_interrupt:
	sw	$a1, STATION_ENTER_ACK   # acknowledge interrupt

	la	$t0, station_in			# ???
        li      $t1, 1
	sb	$t1, 0($t0)		# ???

	j	interrupt_dispatch	# see if other interrupts are waiting

stationex_interrupt:
	sw	$a1, STATION_EXIT_ACK   # acknowledge interrupt

	la	$t0, station_in
	sb	$0, 0($t0)		# ???

	j	interrupt_dispatch	# see if other interrupts are waiting

non_intrpt:				# was some non-interrupt
	li	$v0, PRINT_STRING
	la	$a0, non_intrpt_str
	syscall				# print out an error message
	# fall through to done

done:
	la	$k0, chunkIH
	lw	$a0, 0($k0)		# Restore saved registers
	lw	$a1, 4($k0)
.set noat
	move	$at, $k1		# Restore $at
.set at 
	eret

