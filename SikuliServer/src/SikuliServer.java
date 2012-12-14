import java.util.Properties;
import java.io.File;
import java.io.IOException;

import com.google.gson.Gson;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;

public class SikuliServer extends NanoHTTPD
{
  private boolean serverRunning = false;

  public SikuliServer() throws IOException
  {
    super(7114, new File("."));
    serverRunning = true;
  }

  public boolean getServerRunning()
  {
    return serverRunning;
  }

  public Response serve(String uri, String method, Properties header, Properties params, Properties files )
  {
    return new NanoHTTPD.Response(HTTP_OK, MIME_HTML, "sikuli-server");
  }

  private NanoHTTPD.Response showException(Throwable throwable)
  {
    final Writer result = new StringWriter();
    final PrintWriter printWriter = new PrintWriter(result);
    throwable.printStackTrace(printWriter);
    return new NanoHTTPD.Response(HTTP_OK, MIME_HTML, "error: " + throwable.getMessage() + "\n" + result.toString());
  }
}
