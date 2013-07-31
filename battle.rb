class Battle
    attr_accessor :fighters, :showProgress;
    def initialize(fighters, progress = true)
        @showProgress = progress;
        fighters.each{|x| add(Fighter.subclasses.sample().new(x));};
        run;
    end

    def add fighter
        @fighters ||= []
        @fighters << fighter
    end

    def run
        if fighters.length < 2 then p "Minimum of 2 fighters required." else
            fighterString = fighters.map{|p| "\x03#{p.color}#{p.name}\x0F (\x035#{p.class.to_s}\x0F)" }.join(", ")
            puts "The battle starts with #{fighters.length} fighters: #{fighterString}";
            while fighters.length > 1 do
                attacker, victim = fighters.sample(2)
                weapon = attacker.weapons.sample()
                damage = rand(weapon.min_damage..weapon.max_damage)
                victim.health -= damage
                if victim.health <= 0 then
                    puts "\x03#{attacker.color}#{attacker.name}\x0F does \x02#{damage}\xF damage to \x03#{victim.color}#{victim.name}\x0F and\x035 kills #{victim.name}\xF (#{victim.health}hp left) using attack \x02#{weapon.name}\x0F.";
                    fighters.delete(victim);
                elsif @showProgress then
                    puts "\x03#{attacker.color}#{attacker.name}\x0F does \x02#{damage}\x0F damage to \x03#{victim.color}#{victim.name}\x0F using attack \x02#{weapon.name}\x0F";
                end
            end
            fighters.each{|winner| puts "\x03#{winner.color}#{winner.name} won\x0F#{if winner.health == 100 then ' flawless!!' end}!"};
        end
    end
end

class Fighter
    attr_accessor :name, :health, :color, :weapons;
    @@colors = ["02","03","04","05","06","07","10","12"].shuffle()
    def initialize(name)
        @health = 100;
        @name = name;
        @color = @@colors.shift() || "01" 
    end

    def add weapon
        @weapons ||= []
        @weapons << weapon
    end
end

class BruceLee < Fighter
    def initialize(name)
        super(name)
        add(Weapon.new('Single Direct Attack', 0, 20));
        add(Weapon.new('Attack By Combination', 20, 40));
        add(Weapon.new('Progressive Indirect Attack', 40, 60));
        add(Weapon.new('(Hand) Immobilization Attack', 60, 80));
        add(Weapon.new('Attack by Drawing', 80, 100));
    end
end
class Goku < Fighter
    def initialize(name)
        super(name)
        add(Weapon.new('Tail Attack', 0, 20));
        add(Weapon.new('Dragon Fist', 20, 40));
        add(Weapon.new('Kamehameha', 40, 60));
        add(Weapon.new('Solar Flare', 60, 80));
        add(Weapon.new('Spirit Bomb', 80, 100));
    end
end
class Ryu < Fighter
    def initialize(name)
        super(name)
        add(Weapon.new('Punch', 0, 25));
        add(Weapon.new('Kick', 0, 25));
        add(Weapon.new('Hard Punch', 25, 50));
        add(Weapon.new('Hard Kick', 25, 50));
        add(Weapon.new('Hadoken', 50, 100));
        add(Weapon.new('Hurricane kick', 50, 100));
        add(Weapon.new('Shoryuken', 50, 100));
    end
end
class SEOMaster < Fighter
    def initialize(name)
        super(name)
        add(Weapon.new('Meta Tag', 0, 20));
        add(Weapon.new('Google Search', 20, 50));
        add(Weapon.new('Ejaculaat', 50, 100));
    end
end

class Executioner < Fighter
    def initialize(name)
        super(name)
        add(Weapon.new('Stoning', 0, 20));
        add(Weapon.new('Skinning', 20, 50));
        add(Weapon.new('Dismemberment', 50, 100));
    end
end

class Gaetan < Fighter
    def initialize(name)
        super(name)
        add(Weapon.new('MSN', 0, 1));
        add(Weapon.new('Smakken', 99, 99));
        add(Weapon.new('Angela', 0, 1));
    end
end

class Weapon
    attr_accessor :name, :min_damage, :max_damage, :context;
    def initialize(name, min_damage, max_damage, context = '%s')
        @name = name;
        @min_damage = min_damage;
        @max_damage = max_damage;
        @context = context;
    end
    
end

BEGIN {
   class Class
     def inherited other
       super if defined? super
     ensure
       ( @subclasses ||= [] ).push(other).uniq!
     end

     def subclasses
       @subclasses ||= []
       @subclasses.inject( [] ) do |list, subclass|
         list.push(subclass, *subclass.subclasses)
       end
     end
   end
}
