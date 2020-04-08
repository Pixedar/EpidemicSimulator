import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;
import com.jogamp.opengl.GL;
import com.jogamp.opengl.GL2ES2;
class Renderer {
  private float[] positions;
  private float[] colors;
  private int[] indices;
  FloatBuffer posBuffer;
  FloatBuffer colorBuffer;
  IntBuffer indexBuffer;

  private int posVboId;
  private int colorVboId;
  private int indexVboId;

  private int posLoc; 
  private int colorLoc;

  private PJOGL pgl;
  private GL2ES2 gl;

  public Renderer(int length) {  
    positions = new float[length*2];
    colors = new float[length*4];
    indices = new int[length];

    posBuffer = allocateDirectFloatBuffer(length*2);
    colorBuffer = allocateDirectFloatBuffer(length*4); 
    indexBuffer = allocateDirectIntBuffer(length-1);
    init();
  }

  public Renderer(FloatBuffer posBuffer, FloatBuffer colorBuffer, IntBuffer indexBuffer) {
    this.posBuffer = posBuffer;
    this.colorBuffer = colorBuffer;
    this.indexBuffer = indexBuffer;
    init();
  }

  void init() {
    pgl = (PJOGL) beginPGL();  
    gl = pgl.gl.getGL2ES2();

    // Get GL ids for all the buffers
    IntBuffer intBuffer = IntBuffer.allocate(3);  
    gl.glGenBuffers(3, intBuffer);
    posVboId = intBuffer.get(0);
    colorVboId = intBuffer.get(1);
    indexVboId = intBuffer.get(2);    

    // Get the location of the attribute variables.
    shader.bind();
    posLoc = gl.glGetAttribLocation(shader.glProgram, "position");
    colorLoc = gl.glGetAttribLocation(shader.glProgram, "color");
    shader.unbind();

    endPGL();
  }

  void drawGL(float[] positions, float[] colors, int[] indices) {

    // Geometry transformations from Processing are automatically passed to the shader
    // as long as the uniforms in the shader have the right names.

    updateGeometry(positions, colors, indices);

    pgl = (PJOGL) beginPGL();  
    gl = pgl.gl.getGL2ES2();

    shader.bind();
    gl.glEnableVertexAttribArray(posLoc);
    gl.glEnableVertexAttribArray(colorLoc);  

    // Copy vertex data to VBOs
    gl.glBindBuffer(GL.GL_ARRAY_BUFFER, posVboId);
    gl.glBufferData(GL.GL_ARRAY_BUFFER, Float.BYTES * positions.length, posBuffer, GL.GL_DYNAMIC_DRAW);
    gl.glVertexAttribPointer(posLoc, 2, GL.GL_FLOAT, false, 2 * Float.BYTES, 0);

    gl.glBindBuffer(GL.GL_ARRAY_BUFFER, colorVboId);  
    gl.glBufferData(GL.GL_ARRAY_BUFFER, Float.BYTES * colors.length, colorBuffer, GL.GL_DYNAMIC_DRAW);
    gl.glVertexAttribPointer(colorLoc, 4, GL.GL_FLOAT, false, 4 * Float.BYTES, 0);

    gl.glBindBuffer(GL.GL_ARRAY_BUFFER, 0);

    // Draw the triangle elements
    gl.glBindBuffer(PGL.ELEMENT_ARRAY_BUFFER, indexVboId);
    pgl.bufferData(PGL.ELEMENT_ARRAY_BUFFER, Integer.BYTES * indices.length, indexBuffer, GL.GL_DYNAMIC_DRAW);
    gl.glDrawElements(PGL.POINTS, indices.length, GL.GL_UNSIGNED_INT, 0);
    gl.glBindBuffer(PGL.ELEMENT_ARRAY_BUFFER, 0);    

    gl.glDisableVertexAttribArray(posLoc);
    gl.glDisableVertexAttribArray(colorLoc); 
    shader.unbind();

    endPGL();
  }

  //void getPixelsBuff() {
  //  gl.glReadPixels(0, 0, (int)(img.width*size), (int)(img.height*size), PGL.RGB, PGL.UNSIGNED_BYTE, pixelsBuff);
  //}

  void updateGeometry(float[] positions, float[] colors, int[] indices) {
    posBuffer.rewind();
    posBuffer.put(positions);
    posBuffer.rewind();

    colorBuffer.rewind();
    colorBuffer.put(colors);
    colorBuffer.rewind();

    indexBuffer.rewind();
    indexBuffer.put(indices);
    indexBuffer.rewind();
  }  

  FloatBuffer allocateDirectFloatBuffer(int n) {
    return ByteBuffer.allocateDirect(n * Float.BYTES).order(ByteOrder.nativeOrder()).asFloatBuffer();
  }

  IntBuffer allocateDirectIntBuffer(int n) {
    return ByteBuffer.allocateDirect(n * Integer.BYTES).order(ByteOrder.nativeOrder()).asIntBuffer();
  }
}
