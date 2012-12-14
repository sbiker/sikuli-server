import java.io.IOException;
import java.lang.InterruptedException;

public class Main {
  public static void main (String[] args) throws IOException
  {
    SikuliServer server = new SikuliServer();
    while (server.getServerRunning())
    {
      try {
        Thread.sleep(1);
      }
      catch (InterruptedException exception) {}
    }
  }
}
