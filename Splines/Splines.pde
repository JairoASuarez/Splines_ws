/**
 * Splines.
 *
 * Here we use the interpolator.keyFrames() nodes
 * as control points to render different splines.
 *
 * Press ' ' to change the spline mode.
 * Press 'g' to toggle grid drawing.
 * Press 'c' to toggle the interpolator path drawing.
 * Press 'b' to toggle the Cubic Bezier Spline 
 */

import frames.input.*;
import frames.primitives.*;
import frames.core.*;
import frames.processing.*;

// global variables
// modes: 0 natural cubic spline; 1 Hermite;
// 2 (degree 7) Bezier; 3 Cubic Bezier
int mode;

Scene scene;
Interpolator interpolator;
OrbitNode eye;
boolean drawGrid = true, drawCtrl = true, drawCubic = true, drawHermite = true;

//Choose P3D for a 3D scene, or P2D or JAVA2D for a 2D scene
String renderer = P3D;

void setup() {
  size(800, 800, renderer);
  scene = new Scene(this);
  eye = new OrbitNode(scene);
  eye.setDamping(0);
  scene.setEye(eye);
  scene.setFieldOfView(PI / 3);
  //interactivity defaults to the eye
  scene.setDefaultGrabber(eye);
  scene.setRadius(150);
  scene.fitBallInterpolation();
  interpolator = new Interpolator(scene, new Frame());
  // framesjs next version, simply go:
  //interpolator = new Interpolator(scene);

  // Using OrbitNodes makes path editable
  for (int i = 0; i < 8; i++) {
    Node ctrlPoint = new OrbitNode(scene);
    ctrlPoint.randomize();
    interpolator.addKeyFrame(ctrlPoint);
  }
}

void draw() {
  background(175);
  if (drawGrid) {
    stroke(255, 255, 0);
    scene.drawGrid(200, 50);
  }
  if (drawCtrl) {
    fill(255, 0, 0);
    stroke(255, 0, 255);
    for (Frame frame : interpolator.keyFrames())
      scene.drawPickingTarget((Node)frame);
  } else {
    fill(255, 0, 0);
    stroke(255, 0, 255);
    scene.drawPath(interpolator);
  }
  // implement me
  // draw curve according to control polygon an mode
  // To retrieve the positions of the control points do:
  // for(Frame frame : interpolator.keyFrames())
  //   frame.position();
  //for(Frame frame : interpolator.keyFrames()){
  //println(frame.position());
  //}
  //println(interpolator.keyFrames().get(1).position());

  //Points
  Vector p0 = interpolator.keyFrames().get(0).position();
  Vector p1 = interpolator.keyFrames().get(1).position();
  Vector p2 = interpolator.keyFrames().get(2).position();
  Vector p3 = interpolator.keyFrames().get(3).position();
  Vector p4 = interpolator.keyFrames().get(4).position();
  Vector p5 = interpolator.keyFrames().get(5).position();
  Vector p6 = interpolator.keyFrames().get(6).position();
  Vector p7 = interpolator.keyFrames().get(7).position();
  Vector middle = new Vector((p3.x()+p4.x())/2, (p3.y()+p4.y())/2, (p3.z()+p4.z())/2);
    
  if(drawCubic){
    //Rect
    Vector aux = new Vector((middle.x()-p2.x())*2, (middle.y()-p2.y())*2, (middle.z()-p2.z())*2);  
    interpolator.keyFrames().get(5).setPosition(aux);
  
    //Put P3 & P4 together  
    interpolator.keyFrames().get(3).setPosition(middle);
    interpolator.keyFrames().get(4).setPosition(middle);
  
    //Draw First part of Cubic Hermite Spline
    noFill();
    strokeWeight(2.0);
    strokeJoin(ROUND);
    beginShape();
    vertex(p0.x(), p0.y(), p0.z());
    for (double t=0.0; t<=1.0; t+=0.01) {
      float x = (float)(Math.pow((1-t), 3)*p0.x() + 3*Math.pow((1-t), 2)*t*p1.x() + 3*(1-t)*t*t*p2.x() + t*t*t*middle.x());
      float y = (float)(Math.pow((1-t), 3)*p0.y() + 3*Math.pow((1-t), 2)*t*p1.y() + 3*(1-t)*t*t*p2.y() + t*t*t*middle.y());
      float z = (float)(Math.pow((1-t), 3)*p0.z() + 3*Math.pow((1-t), 2)*t*p1.z() + 3*(1-t)*t*t*p2.z() + t*t*t*middle.z());
      vertex(x, y, z);
    }
    endShape(); 
  
    //Draw Second part of Cubic Hermite Spline
    noFill();
    strokeWeight(2.0);
    strokeJoin(ROUND);
    beginShape();
    vertex(p4.x(), p4.y(), p4.z());
    for (double t=0.0; t<=1.0; t+=0.01) {
      float x = (float)(Math.pow((1-t), 3)*middle.x() + 3*Math.pow((1-t), 2)*t*p5.x() + 3*(1-t)*t*t*p6.x() + t*t*t*p7.x());
      float y = (float)(Math.pow((1-t), 3)*middle.y() + 3*Math.pow((1-t), 2)*t*p5.y() + 3*(1-t)*t*t*p6.y() + t*t*t*p7.y());
      float z = (float)(Math.pow((1-t), 3)*middle.z() + 3*Math.pow((1-t), 2)*t*p5.z() + 3*(1-t)*t*t*p6.z() + t*t*t*p7.z());
      vertex(x, y, z);
    }
    endShape();
  }
  
  if(drawHermite){
    //Draw First Part of Hermite Spline
    noFill();
    strokeWeight(2.0);
    strokeJoin(ROUND);
    beginShape();
    vertex(p0.x(), p0.y(), p0.z());
    for (double t=0.0; t<=1.0; t++) {
      float t1 = (float)(2*Math.pow(t,3)-3*Math.pow(t,2)+1);
      float t2 = (float)(Math.pow(t,3)-2*Math.pow(t,2)+t);
      float t3 = (float)(-2*Math.pow(t,3)+3*Math.pow(t,2));
      float t4 = (float)(Math.pow(t,3)-Math.pow(t,2));
      float x = t1*p1.x()+t2*p2.x()+t3*p3.x()+t4*middle.x();
      float y = t1*p1.y()+t2*p2.y()+t3*p3.y()+t4*middle.y();
      float z = t1*p1.z()+t2*p2.z()+t3*p3.z()+t4*middle.z();
      vertex(x, y, z);
    }
    endShape();
    
    //Draw First Part of Hermite Spline
    noFill();
    strokeWeight(2.0);
    strokeJoin(ROUND);
    beginShape();
    vertex(middle.x(), middle.y(), middle.z());
    for (double t=0.0; t<=1.0; t++) {
      float t1 = (float)(2*Math.pow(t,3)-3*Math.pow(t,2)+1);
      float t2 = (float)(Math.pow(t,3)-2*Math.pow(t,2)+t);
      float t3 = (float)(-2*Math.pow(t,3)+3*Math.pow(t,2));
      float t4 = (float)(Math.pow(t,3)-Math.pow(t,2));
      float x = t1*middle.x()+t2*p5.x()+t3*p6.x()+t4*p7.x();
      float y = t1*middle.y()+t2*p5.y()+t3*p6.y()+t4*p7.y();
      float z = t1*middle.z()+t2*p5.z()+t3*p6.z()+t4*p7.z();
      vertex(x, y, z);
    }
    endShape();
  }
}

void keyPressed() {
  if (key == ' ')
    mode = mode < 3 ? mode+1 : 0;
  if (key == 'g')
    drawGrid = !drawGrid;
  if (key == 'c')
    drawCtrl = !drawCtrl;
  if (key == 'b')
    drawCubic = !drawCubic;
  if (key == 'h')
    drawHermite = !drawHermite;
}