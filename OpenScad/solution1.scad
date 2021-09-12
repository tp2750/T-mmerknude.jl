Unit=5;
Slack=1.5;
Laengde=12*Unit;
Bredde=2*Unit;
keys = [[0,1,2,0,0,0,0,0],
        [1,2,2,1,1,1,1,1],
        [2,1,1,2,0,1,1,0],
        [0,2,1,0,0,1,1,0],
        [2,1,2,2,0,0,1,0],
        [1,2,2,1,1,1,0,0]];
        
module cut(key){
    for (i = [0:3]) {
        if (key[i]!=0) {
            translate([(i)*Unit,-Unit,0])
            cube([Unit+Slack,key[i]*Unit+Slack,Unit+Slack],center=false);
        }
    }
    for (i = [4:7]) {
        if (key[i]!=0) {
            translate([(i-4)*Unit,-Unit,-Unit])
            cube([Unit+Slack,key[i]*Unit+Slack,Unit+Slack],center=false);
        }
    }
}

module pind(){
cube([Laengde,Bredde,Bredde], center = true);
} 

module stick(key) {
    difference(){
    pind();
    translate([-2*Unit-Slack/2,-Slack/2,-Slack/2])
        cut(key);
    }
}

translate([0,0,2*Unit])
  rotate(-90,[0,0,1])      
      rotate(-90,[1,0,0])      
        stick(keys[0]); // 1

translate([0,0,0*Unit])
  rotate(-90,[0,0,1])      
      rotate(0,[1,0,0])      
        stick(keys[4]); // 5

translate([0,-1*Unit,1*Unit])
  rotate(0,[0,0,1])      
      rotate(-90,[1,0,0])      
        stick(keys[2]); // 3

translate([-1*Unit,0*Unit,1*Unit])
  rotate(90,[0,1,0])      
      rotate(-90,[1,0,0])      
        stick(keys[1]); // 2

translate([0,1*Unit,1*Unit])
  rotate(180,[0,1,0])      
      rotate(90,[1,0,0])      
        stick(keys[3]); // 4

translate([1*Unit,0*Unit,1*Unit])
  rotate(-90,[0,0,1])
    rotate(-90,[0,1,0])      
      rotate(-0,[1,0,0])      
            stick(keys[5]); // 6

