<%-- 
    Document   : ubicacionesConsultas
    Created on : 26/11/2014, 07:39:54 AM
    Author     : Americo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <!-- Estilos CSS -->
        <link href="css/bootstrap.css" rel="stylesheet">
        <link rel="stylesheet" href="css/cupertino/jquery-ui-1.10.3.custom.css" />
        <link href="css/navbar-fixed-top.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="css/dataTables.bootstrap.css">
        <!---->
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SIALSS</title>
    </head>
    <body class="container">
        <h1>SIALSS</h1>
        <hr />
        <div class="row small">
            <h4 class="col-sm-1">Clave</h4>
            <div class="col-sm-2">
                <input class="form-control " placeholder="Clave" />
            </div>
            <h4 class="col-sm-1">Lote</h4>
            <div class="col-sm-2">
                <input class="form-control" placeholder="Lote" />
            </div>
            <h4 class="col-sm-1">CB Ubi</h4>
            <div class="col-sm-2">
                <input class="form-control" placeholder="CB Ubicación" />
            </div>
            <h4 class="col-sm-1">CB Med</h4>
            <div class="col-sm-2">
                <input class="form-control" placeholder="CB Insumo" />
            </div>
        </div>
        <br/>
        <div class="row small">
            <div class="col-sm-2">
                <button class="btn btn-block btn-primary btn-sm">Buscar</button>
            </div>
            <div class="col-sm-2">
                <button class="btn btn-block btn-primary btn-sm">Por Ubicar</button>
            </div>
            <div class="col-sm-2">
                <button class="btn btn-block btn-primary btn-sm">Mostrar Todas</button>
            </div>
        </div>
        <br/><br/>
        <table class="table table-condensed table-bordered table-striped">
            <tr>
                <td>Clave</td>
                <td>Lote</td>
                <td>Caducidad</td>
                <td>Ubicación</td>
                <td>Piezas</td>
            </tr>
        </table>
        <hr/>
        <h3>Total de Piezas:</h3>
    </body>
    <!-- 
    ================================================== -->
    <!-- Se coloca al final del documento para que cargue mas rapido -->
    <!-- Se debe de seguir ese orden al momento de llamar los JS -->
    <script src="js/jquery-1.9.1.js"></script>
    <script src="js/bootstrap.js"></script>
    <script src="js/jquery-ui-1.10.3.custom.js"></script>
    <script src="js/jquery.dataTables.js"></script>
    <script src="js/dataTables.bootstrap.js"></script>
</html>
