<%-- 
    Document   : index
    Created on : 17/02/2014, 03:34:46 PM
    Author     : Americo
--%>

<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="conn.*" %>
<!DOCTYPE html>
<%java.text.DateFormat df = new java.text.SimpleDateFormat("yyyyMMddhhmmss"); %>
<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%java.text.DateFormat df3 = new java.text.SimpleDateFormat("dd/MM/yyyy"); %>
<%

    HttpSession sesion = request.getSession();
    String usua = "", tipo = "";
    if (sesion.getAttribute("nombre") != null) {
        usua = (String) sesion.getAttribute("nombre");
        tipo = (String) sesion.getAttribute("Tipo");
    } else {
        response.sendRedirect("index.jsp");
    }
    ConectionDB con = new ConectionDB();
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Estilos CSS -->
        <link href="../css/bootstrap.css" rel="stylesheet">
        <link rel="stylesheet" href="../css/cupertino/jquery-ui-1.10.3.custom.css" />
        <link href="../css/navbar-fixed-top.css" rel="stylesheet">
        <!---->
        <title>SIALSS</title>
    </head>
    <body>
        <div class="container">
            <h1>SIALSS</h1>
            <h4>Módulo - Sistema de Administración de Almacenes (SAA)</h4>
            <hr/>
            <h3>Capturar Claves</h3>

            <form id="formBusca" method="post">
                <div class="row">
                    <div class="col-sm-1">
                        <h4>Búsqueda:</h4>
                    </div>
                    <div class="col-sm-2">
                        <input class="form-control" placeholder="Ingresa CB Ubi" id="buscarUbi" name="buscarUbi"/>
                    </div>
                    <div class="col-sm-2">
                        <input class="form-control" placeholder="Ingresa CB Med" id="buscarMed"/>
                    </div>
                    <div class="col-sm-4">
                        <input class="form-control" placeholder="Ingrese Descripción" id="buscarDescrip"/>
                    </div>
                    <div class="col-sm-2">
                        <button class="btn btn-block btn-primary" id="btnBuscar">Buscar</button>
                    </div>
                </div>
            </form>
            <hr/>
            <form name="formIngresa" id="formIngresa" method="post">
                <div class="row">
                    <h4 class="col-sm-1 text-right">Clave</h4>
                    <div class="col-sm-2">
                        <input class="form-control" placeholder="Clave" id="F_ClaPro" name="F_ClaPro"/>
                    </div>
                    <div class="col-sm-2">
                        <select class="form-control" id="selectClave" onchange="cambiaLoteCadu(this)">
                            <option value="">--Clave--</option>
                        </select>
                    </div>
                    <h4 class="col-sm-1 text-right" >Lote</h4>
                    <div class="col-sm-2">
                        <input class="form-control" placeholder="Lote" id="F_ClaLot" name="F_ClaLot"/>
                    </div>
                    <div class="col-sm-2">
                        <select class="form-control" id="selectLote">
                            <option value="">--Lote--</option>
                        </select>
                    </div>
                </div>
                <div class="row">
                    <h4 class="col-sm-1 text-right" >Cadu</h4>
                    <div class="col-sm-2">
                        <input class="form-control" placeholder="Caducidad" id="F_FecCad" name="F_FecCad"/>
                    </div>
                    <div class="col-sm-2">
                        <select class="form-control" id="selectCadu">
                            <option value="">--Caducidad--</option>
                        </select>
                    </div>
                </div>
                <br/>
                <div class="row">
                    <h4 class="col-sm-1 text-right" >Ubicación</h4>
                    <div class="col-sm-2">
                        <input class="form-control" placeholder="Ubi" id="F_ClaUbi" name="F_ClaUbi"/>
                    </div>
                    <h4 class="col-sm-1 text-right" >Present</h4>
                    <div class="col-sm-2">
                        <input class="form-control" placeholder="Present" id="F_Presentacion" name="F_Presentacion" />
                    </div><div class="col-sm-2">
                        <select class="form-control" id="selectResto">
                            <option value="">Presentación</option>
                            <option value="Resto">Resto</option>
                        </select>
                    </div>
                </div>
                <hr/>
                <div class="row">
                    <h4 class="col-sm-2 text-right col-sm-offset-1" >Total Existencias</h4>
                    <div class="col-sm-2">
                        <input class="form-control" placeholder="Total" id="F_Total" name="F_Total" />
                    </div>
                    <div class="col-sm-2">
                        <button class="btn btn-block btn-primary" id="btnGuardar">Guardar</button>
                    </div>
                </div>
            </form>
            <hr/>
            <div class="table-responsive" id="tbInsumo">
                <table class="table table-striped table-bordered table-condensed">
                    <tr>
                        <td>Clave</td>
                        <td>Lote</td>
                        <td>Caducidad</td>
                        <td>Ubicación</td>
                        <td>Cantidad</td>
                        <td></td>
                    </tr>
                    <%
                        try {
                            con.conectar();
                            ResultSet rset = con.consulta("select * from tb_loteinv where F_ExiLot!=0 and F_Ubica='" + request.getParameter("F_Ubica") + "'");
                            while (rset.next()) {
                    %>
                    <tr>
                        <td><%=rset.getString("F_ClaPro")%></td>
                        <td><%=rset.getString("F_ClaLot")%></td>
                        <td><%=rset.getString("F_FecCad")%></td>
                        <td><%=rset.getString("F_Ubica")%></td>
                        <td><%=rset.getString("F_ExiLot")%></td>
                        <td><button class="btn btn-sm btn-danger"><span class="glyphicon glyphicon-remove"></span></button></td>
                    </tr>
                    <%
                            }
                            con.cierraConexion();
                        } catch (Exception e) {

                        }
                    %>
                </table>
            </div>
            <br><br><br>
            <div class="navbar  navbar-inverse">
                <div class="text-center text-muted">
                    GNK Logística || Desarrollo de Aplicaciones 2009 - 2014 <span class="glyphicon glyphicon-registration-mark"></span><br />
                    Todos los Derechos Reservados
                </div>
            </div>
    </body>
    <!-- 
    ================================================== -->
    <!-- Se coloca al final del documento para que cargue mas rapido -->
    <!-- Se debe de seguir ese orden al momento de llamar los JS -->
    <script src="../js/jquery-1.9.1.js"></script>
    <script src="../js/bootstrap.js"></script>
    <script src="../js/funcInvCiclico.js"></script>
    <script src="../js/jquery-ui.js"></script>
</html>

