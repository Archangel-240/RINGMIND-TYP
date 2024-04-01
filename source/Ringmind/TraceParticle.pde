//------------------------------------TRACE PARTICLE--------------------------------------------

class TraceParticle {

    PVector position = new PVector();
    PVector lastPos = new PVector();
    color c = color(0,0,0);

    TraceParticle(){
    }

    TraceParticle(Particle sp){
        position = sp.position.copy();
        lastPos = sp.lastPos.copy();
        c = sp.c;
    }
}
