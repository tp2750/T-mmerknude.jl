Unit=5;
Slack=.3; // 0.3 for printing, 3 for viewing solution
Laengde=12*Unit;
Bredde=2*Unit;
keys = [[0,0,0,0,0,0,0,0],
        [2,2,2,2,0,0,0,0],
        [2,2,2,2,0,0,0,0],
        [1,2,2,1,1,1,1,1],
        [1,2,2,1,1,1,1,1],
        [2,0,0,2,0,0,0,0]];
        
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
cube([Laengde-Slack/2,Bredde-Slack/2,Bredde-Slack/2], center = true);
} 

module stick(key) {
    difference(){
    pind();
    translate([-2*Unit-Slack/2,-Slack/2,-Slack/2])
        cut(key);
    }
}

translate([0,40,0])
for (i = [0:5] ) {
translate([0,i*2*(Unit+Slack),0])
stick(keys[i]);
}



// Comment out (*) for printing sticks
 translate([0,0,0]){
translate([0,0,3*Unit])
  rotate(0,[0,0,1])      
      rotate(0,[1,0,0])      
        stick(keys[0]); // 1

translate([0,Unit,2*Unit])
  rotate(90,[0,0,1])      
      rotate(-90,[0,1,0])      
        stick(keys[1]); // 5

translate([0,-1*Unit,2*Unit])
  rotate(90,[0,0,1])      
      rotate(90,[0,1,0])      
        stick(keys[2]); // 3

translate([1*Unit,0*Unit,1*Unit])
  rotate(-90,[0,0,1])      
      rotate(-0,[1,0,0])      
        stick(keys[3]); // 2

translate([-1*Unit,0,1*Unit])
  rotate(90,[0,0,1])      
      rotate(0,[1,0,0])      
        stick(keys[4]); // 4

translate([0*Unit,0*Unit,1*Unit])
  rotate(-0,[0,0,1])
    rotate(-0,[0,1,0])      
      rotate(180,[1,0,0])      
            stick(keys[5]); // 6

}