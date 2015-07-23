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

    /**
     * Administración de las remisiones elaboradas
     */
    HttpSession sesion = request.getSession();
    String usua = "";
    String tipo = "";
    if (sesion.getAttribute("nombre") != null) {
        usua = (String) sesion.getAttribute("nombre");
        tipo = (String) sesion.getAttribute("Tipo");
    } else {
        response.sendRedirect("index.jsp");
    }
    ConectionDB con = new ConectionDB();

    String fol_gnkl = "", fol_remi = "", orden_compra = "", fecha = "";
    try {
        if (request.getParameter("accion").equals("buscar")) {
            fol_gnkl = request.getParameter("fol_gnkl");
            fol_remi = request.getParameter("fol_remi");
            orden_compra = request.getParameter("orden_compra");
            fecha = request.getParameter("fecha");
        }
    } catch (Exception e) {

    }
    if (fol_gnkl == null) {
        fol_gnkl = "";
        fol_remi = "";
        orden_compra = "";
        fecha = "";
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Estilos CSS -->
        <link href="css/bootstrap.css" rel="stylesheet">
        <link rel="stylesheet" href="css/cupertino/jquery-ui-1.10.3.custom.css" />
        <!--link href="css/navbar-fixed-top.css" rel="stylesheet"-->
        <link href="css/datepicker3.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="css/dataTables.bootstrap.css">
        <!---->
        <title>SIALSS</title>
    </head>
    <body>
        <div class="container">
            <h1>SIALSS</h1>
            <h4>SISTEMA INTEGRAL DE ADMINISTRACIÓN Y LOGÍSTICA PARA SERVICIOS DE SALUD</h4>

            <%@include file="jspf/menuPrincipal.jspf"%>

            <div class="row">
                <h3 class="col-sm-3">Administrar Remisiones</h3>
                <div class="col-sm-2 col-sm-offset-5">
                    <br/>
                    <a class="btn btn-success" href="gnrFacturaConcentrado.jsp?fecha=2014" target="_blank">Exportar Global 2014</a>
                </div>
                <div class="col-sm-2">
                    <br/>
                    <a class="btn btn-success" href="gnrFacturaConcentrado.jsp?fecha=2015" target="_blank">Exportar Global 2015</a>
                </div>
                <br/>
            </div>
            <div class="row">
                <label class="col-sm-2">Filtrar por fecha</label>
                <div class="col-sm-2">
                    <input class="form-control" type="text" id="fIni" name="fIni" data-date-format="yyyy/mm/dd">
                </div>
                <div class="col-sm-2">
                    <input class="form-control" type="text" id="fFin" name="fFin" data-date-format="yyyy/mm/dd">
                </div>
                <div class="col-sm-1">
                    <button class="btn btn-info" id="btnBuscarFecha" name="btnBuscarFecha" type="button" ><span class="glyphicon glyphicon-search"></span></button>
                </div>
                <div class="col-sm-2">
                    <button class="btn btn-success" id="btnRestablecer" name="btnRestablecer" type="button" >Restablecer</button>
                </div>
            </div>
            <div>
                <br />
                <div class="panel panel-primary">
                    <div class="panel-body table-responsive">
                        <table class="table table-bordered table-striped" id="datosCompras">
                            <thead>
                                <tr><td>E.S</td>
                                    <td>No. Folio</td>
                                    <td>Punto de Entrega</td>
                                    <td>Fecha de Entrega</td>
                                    <td>Imprimir</td>
                                    <td>Ver Factura</td>
                                    <td>Devolución</td>
                                    <%                                        if (usua.equals("oscar") || tipo.equals("8")) {
                                            out.println("<td>Reintegrar Insumo</td>");
                                        }
                                    %>
                                    <td>Excel</td>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    /**
                                     * Listado de las remisiones
                                     *
                                     * el where es para que se definan los
                                     * parametros de fechas de busqueda de las
                                     * remisiones
                                     */
                                    String where = "";
                                    try {
                                        if (session.getAttribute("whereRF") == null) {
                                            where = "WHERE F.F_FecEnt BETWEEN '01/01/01' AND '01/01/01'";
                                        } else {

                                            where = session.getAttribute("whereRF").toString();
                                        }
                                    } catch (Exception ex) {
                                        where = "WHERE F.F_FecEnt BETWEEN '01/01/01' AND '01/01/01'";
                                    }
                                    try {
                                        con.conectar();
                                        try {
                                            ResultSet rset = con.consulta("SELECT F.F_ClaDoc,F.F_ClaCli,U.F_NomCli,DATE_FORMAT(F.F_FecApl,'%d/%m/%Y') AS F_FecApl,SUM(F.F_Monto) AS F_Costo,DATE_FORMAT(F.F_FecEnt,'%d/%m/%Y') AS F_FecEnt FROM tb_factura F INNER JOIN tb_uniatn U ON F.F_ClaCli=U.F_ClaCli " + where + " GROUP BY F.F_ClaDoc ORDER BY F.F_ClaDoc+0;");
                                            while (rset.next()) {

                                %>
                                <tr>
                                    <td><input class="checkbox-inline" value="<%=rset.getString(1)%>" onchange="ChkEnviaSendero(this)" type="checkbox" id="chkFac" name="chkFac"></td>
                                    <td><%=rset.getString(1)%></td>
                                    <td><%=rset.getString(3)%></td>
                                    <td><%=rset.getString("F_FecEnt")%></td>
                                    <td>
                                        <form action="reimpFactura.jsp" target="_blank">
                                            <input class="hidden" name="fol_gnkl" value="<%=rset.getString(1)%>">
                                            <button class="btn btn-block btn-primary"><span class="glyphicon glyphicon-print"></span></button>
                                        </form>
                                    </td>
                                    <td>
                                        <form action="verFactura.jsp" method="post">
                                            <input class="hidden" name="fol_gnkl" value="<%=rset.getString(1)%>">
                                            <button class="btn btn-block btn-primary"><span class="glyphicon glyphicon-search"></span></button>
                                        </form>
                                    </td>
                                    <td>
                                        <%
                                            /**
                                             * Para que se muestre el boton de
                                             * devoluciones
                                             */
                                            if (tipo.equals("7") || tipo.equals("8")) {
                                        %>
                                        <form action="devolucionesFacturas.jsp" method="post">
                                            <input class="hidden" name="fol_gnkl" value="<%=rset.getString(1)%>">
                                            <button class="btn btn-block btn-danger"><span class="glyphicon glyphicon-arrow-left"></span></button>
                                        </form>
                                        <%
                                            }
                                        %>
                                    </td>
                                    <%
                                        if (usua.equals("oscar") || tipo.equals("8")) {
                                            /**
                                             * Para aplicar la reintegración de
                                             * las devoluciones
                                             */
                                    %>
                                    <td>
                                        <%
                                            ResultSet rset2 = con.consulta("select * from tb_factdevol where F_ClaDoc = '" + rset.getString(1) + "' group by F_ClaDoc");
                                            while (rset2.next()) {
                                        %>
                                        <form action="reintegrarDevolFact.jsp" method="post">
                                            <input class="hidden" name="fol_gnkl" value="<%=rset2.getString(2)%>">
                                            <button class="btn btn-block btn-info"><span class="glyphicon glyphicon-log-in"></span></button>  
                                        </form>
                                        <%
                                            }
                                        %>
                                    </td>
                                    <%
                                        }
                                    %>
                                    <td>
                                        <a class="btn btn-block btn-success" href="gnrFacturaExcel.jsp?fol_gnkl=<%=rset.getString(1)%>"><span class="glyphicon glyphicon-save"></span></a>
                                    </td>
                                </tr>
                                <%
                                            }
                                        } catch (Exception e) {

                                        }
                                        con.cierraConexion();
                                    } catch (Exception e) {

                                    }
                                %>
                            </tbody>
                        </table>
                        <button  id="btnCedisSendero" class="btn btn-primary right disabled" onclick="return confirm('Seguro de Enviar las Remisiones?')">Enviar CEDIS Sendero</button>
                        <div class="text-center" id="imagenLoader">
                            <img src="imagenes/ajax-loader-1.gif" width="60" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <br><br><br>
        <div class="navbar navbar-fixed-bottom navbar-inverse">
            <div class="text-center text-muted">
                GNK Logística || Desarrollo de Aplicaciones 2009 - 2015 <span class="glyphicon glyphicon-registration-mark"></span><br />
                Todos los Derechos Reservados
            </div>
        </div>
        <!-- 
        ================================================== -->
        <!-- Se coloca al final del documento para que cargue mas rapido -->
        <!-- Se debe de seguir ese orden al momento de llamar los JS -->
        <script src="js/jquery-1.9.1.js"></script>
        <script src="js/bootstrap.js"></script>
        <script src="js/jquery-ui-1.10.3.custom.js"></script>
        <script src="js/bootstrap-datepicker.js"></script>
        <script src="js/jquery.dataTables.js"></script>
        <script src="js/dataTables.bootstrap.js"></script>
        <script>
                            $(document).ready(function() {
                                $('#datosCompras').dataTable();
                                $('#imagenLoader').toggle();
                            });
        </script>
        <script type="text/javascript">
            $(function() {
                $("#fecha").datepicker();
                $("#fecha").datepicker('option', {dateFormat: 'dd/mm/yy'});
                $('#fIni').datepicker();
                $('#fFin').datepicker();
            });
            function ChkEnviaSendero(chk, folio) {
                if (chk.checked === true) {
                    var id = chk.value;
                    var dir = "EnviarCedisSendero";
                    $.ajax({
                        url: dir,
                        data: {que: "add", id: id},
                        success: function(data) {
                            $('#btnCedisSendero').removeClass("disabled");
                            //$('#tbDev').load('devolucionesFacturas.jsp #tbDev');
                        },
                        error: function() {
                            alert("Ocurrió un error");
                        }
                    });
                } else {
                    var id = chk.value;
                    var dir = "EnviarCedisSendero";
                    $.ajax({
                        url: dir,
                        data: {que: "rem", id: id},
                        success: function(data) {
                            //$('#tbDev').load('devolucionesFacturas.jsp #tbDev');
                        },
                        error: function() {
                            alert("Ocurrió un error");
                        }
                    });
                }
            }
            $('#btnCedisSendero').click(function() {
                var dir = "EnviarCedisSendero";
                $('#imagenLoader').toggle();
                $.ajax({
                    url: dir,
                    data: {que: "g"},
                    success: function(data) {
                        //$('#datosCompras').load('reimp_factura.jsp #datosCompras');
                        window.location.reload();
                    },
                    error: function() {
                        alert("Ocurrió un error");
                    }
                });
            });
            $('#btnBuscarFecha').click(function() {
                var fIni = $('#fIni').val();
                var fFin = $('#fFin').val();
                var dir = "EnviarCedisSendero";
                if (fIni === "") {
                    $('#fIni').focus();
                    return false;
                }
                if (fFin === "") {
                    $('#fFin').focus();
                    return false;
                }
                $.ajax({
                    url: dir,
                    data: {que: "b", fIni: fIni, fFin: fFin},
                    success: function(data) {
                        //$('#datosCompras').load('reimp_factura.jsp #datosCompras');
                        window.location.reload();
                    },
                    error: function() {
                        alert("Ocurrió un error");
                    }
                });
            });
            $('#btnRestablecer').click(function() {
                var dir = "EnviarCedisSendero";
                $.ajax({
                    url: dir,
                    data: {que: "r"},
                    success: function(data) {
                        //$('#datosCompras').load('reimp_factura.jsp #datosCompras');
                        window.location.reload();
                    },
                    error: function() {
                        alert("Ocurrió un error");
                    }
                });
            });
        </script>

    </body>
</html>