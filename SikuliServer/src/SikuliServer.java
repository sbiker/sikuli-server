import java.util.Properties;
import java.io.File;
import java.io.IOException;

import com.google.gson.Gson;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;

import org.sikuli.script.*;

public class SikuliServer extends NanoHTTPD
{
  private boolean serverRunning = false;
  private Screen screen;

  public SikuliServer() throws IOException
  {
    super(7114, new File("."));
    screen = new Screen();
    serverRunning = true;
  }

  public boolean getServerRunning()
  {
    return serverRunning;
  }

  public Response serve(String uri, String method, Properties header, Properties params, Properties files)
  {
    if (uri.endsWith("/execute"))
    {
      String methodName = params.getProperty("method");
      String[] parameters = new Gson().fromJson(params.getProperty("parameters"), String[].class);
      if (methodName.equals("focus"))
      {
        App app = new App(parameters[0]);
        app.focus();
        return new NanoHTTPD.Response(HTTP_OK, MIME_HTML, methodName);
      }

      if (methodName.equals("click"))
      {
        try {
          screen.click(parameters[0], 0);
        } catch (org.sikuli.script.FindFailed exception) {
          return showException(exception);
        }
        return new NanoHTTPD.Response(HTTP_OK, MIME_HTML, methodName);
      }
    }

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
