<%-- 
    Document   : index
    Created on : 01-oct-2013, 12:05:12
    Author     : wence
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession sesion = request.getSession();
    String info = null;
    /**
     * Archivo de login
     */
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Ingreso SAA</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Bootstrap -->
        <link href="css/bootstrap.css" rel="stylesheet" media="screen">
        <link href="css/login.css" rel="stylesheet" media="screen">
        <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->

    </head>
    <body>
        <div class="container">

            <form name ="form" id="forma-login" class="marco" action="login" method="post" >
                <!--label for="username" class="uname" data-icon="u" > Your email or username </label-->
                <div class="row">
                    <div class="col-md-4"><img src="imagenes/GNKL_Small.JPG" ></div>
                    <div class="col-md-8"><h2>Validar Usuario</h2></div>

                </div>


                <div class="input-group">
                    <span class="input-group-addon"><label class="glyphicon glyphicon-user"></label>
                    </span>
                    <input type="text" name="nombre" id="nombre" class="form-control" autofocus="" placeholder="Introduzca Nombre de Usuario">
                </div>
                <div class="input-group">
                    <span class="input-group-addon"><label class="glyphicon glyphicon-hand-right"></label>
                    </span>

                    <input type="password" name="pass" id="pass" class="form-control"  placeholder="Introduzca Contrase&ntilde;a V&aacute;lida">
                </div>
                <div>
                    <%
                        /**
                         * Para obtener el mensaje
                         */
                        info = (String) sesion.getAttribute("mensaje");
                        //out.print(info);
                        if (!(info == null || info.equals(null))) {
                    %>
                    <div>Datos inv&aacute;lidos, intente otra vez...</div>
                    <%
                        }
                        sesion.invalidate();

                    %>
                    <!--
                    Bandera de login, nos dice que tipo de login será (SAA o ISEM)
                    -->
                    <input type="hidden" name="ban" value="0" class="form-control">
                </div>
                <br>              
                <button name="envio" class="btn btn-primary btn-lg btn-block" type="submit">Entrar</button>
                <br>
            </form>
            <br>



        </div>

        <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
        <script src="js/jquery-1.9.1.js"></script>
        <!-- Include all compiled plugins (below), or include individual files as needed -->
        <script src="js/bootstrap.js"></script>
    </body>
</html>

