<%-- 
    Document   : index
    Created on : 17/02/2014, 03:34:46 PM
    Author     : Americo
--%>

<%@page import="java.text.DecimalFormatSymbols"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="conn.*" %>
<!DOCTYPE html>
<%java.text.DateFormat df = new java.text.SimpleDateFormat("yyyyMMddhhmmss"); %>
<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%java.text.DateFormat df3 = new java.text.SimpleDateFormat("dd/MM/yyyy"); %>
<%
    /**
     * Para aplicar devoluciones a las facturas generadas
     */
    DecimalFormat formatter = new DecimalFormat("#,###,###");
    DecimalFormat formatterDecimal = new DecimalFormat("#,###,##0.00");
    DecimalFormatSymbols custom = new DecimalFormatSymbols();
    custom.setDecimalSeparator('.');
    custom.setGroupingSeparator(',');
    formatter.setDecimalFormatSymbols(custom);
    formatterDecimal.setDecimalFormatSymbols(custom);
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
    /**
     * Obtención de los parámetros
     */
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

            <div>
                <h3>Devoluciones</h3>
                <h4>Folio de Factura: <%=request.getParameter("fol_gnkl")%></h4>
                <%
                    /**
                     * Se muestran los datos generales de la factura
                     */
                    try {
                        con.conectar();
                        try {
                            ResultSet rset = con.consulta("SELECT U.F_NomCli,DATE_FORMAT(F.F_FecEnt,'%d/%m/%Y') AS F_FecEnt,F.F_ClaDoc,F.F_ClaPro,M.F_DesPro,L.F_ClaLot,DATE_FORMAT(L.F_FecCad,'%d/%m/%Y') AS F_FecCad,SUM(F.F_CantReq) as requerido,SUM(F.F_CantSur) as surtido,F.F_Costo,SUM(F.F_Monto) as importe, F.F_Ubicacion FROM tb_factura F INNER JOIN tb_medica M ON F.F_ClaPro=M.F_ClaPro INNER JOIN tb_lote L ON F.F_Lote=L.F_FolLot INNER JOIN tb_uniatn U ON F.F_ClaCli=U.F_ClaCli WHERE F.F_ClaDoc='" + request.getParameter("fol_gnkl") + "' GROUP BY F.F_ClaDoc");
                            while (rset.next()) {


                %>
                <h4>Cliente: <%=rset.getString(1)%></h4>
                <h4>Fecha de Entrega: <%=rset.getString(2)%></h4>
                <h4>Factura: <%=rset.getString(3)%></h4>
                <%
                    int req = 0, sur = 0;
                    Double imp = 0.0;
                    ResultSet rset2 = con.consulta("SELECT U.F_NomCli,DATE_FORMAT(F.F_FecEnt,'%d/%m/%Y') AS F_FecEnt,F.F_ClaDoc,F.F_ClaPro,M.F_DesPro,L.F_ClaLot,DATE_FORMAT(L.F_FecCad,'%d/%m/%Y') AS F_FecCad,(F.F_CantSur) as surtido,(F.F_CantReq) as requerido,F.F_Costo,(F.F_Monto) as importe, F.F_Ubicacion FROM tb_factura F INNER JOIN tb_medica M ON F.F_ClaPro=M.F_ClaPro INNER JOIN tb_lote L ON F.F_Lote=L.F_FolLot INNER JOIN tb_uniatn U ON F.F_ClaCli=U.F_ClaCli WHERE F.F_ClaDoc='" + request.getParameter("fol_gnkl") + "' GROUP BY U.F_NomCli,F.F_FecEnt,F.F_ClaDoc,F.F_ClaPro,M.F_DesPro,L.F_ClaLot,L.F_FecCad,F.F_CantReq,F.F_CantSur,F.F_Costo,F.F_Monto");
                    while (rset2.next()) {
                        req = req + rset2.getInt("requerido");
                        sur = sur + rset2.getInt("surtido");
                        imp = imp + rset2.getDouble("importe");
                        System.out.println(req);
                    }
                %>

                <div class="row">
                    <h5 class="col-sm-3">Total Solicitado: <%=formatter.format(req)%></h5>
                    <h5 class="col-sm-3">Total Surtido: <%=formatter.format(sur)%></h5>
                    <h5 class="col-sm-3">Total Importe: $ <%=formatterDecimal.format(imp)%></h5>
                    <a href="reimp_factura.jsp" class="btn btn-default">Regresar</a>
                    <a href="reimpDevolucionFactura.jsp?fol_gnkl=<%=request.getParameter("fol_gnkl")%>" target="_blank" class="btn btn-danger">Impr Devolución</a>
                </div>
                <%
                            }
                        } catch (Exception e) {

                        }
                        con.cierraConexion();
                    } catch (Exception e) {

                    }
                %>
                <br />
                <div class="panel panel-primary">
                    <div class="panel-body">
                        <table class="table table-bordered table-striped" id="datosCompras">
                            <thead>
                                <tr>
                                    <td>Clave</td>
                                    <td>Descripción</td>
                                    <td>Lote</td>
                                    <td>Caducidad</td>
                                    <td>Req.</td>
                                    <td>Ubicación</td>
                                    <td>Ent.</td>
                                    <td>Costo U</td>
                                    <td>Importe</td>
                                    <td></td>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try {
                                        con.conectar();
                                        try {
                                            /**
                                             * Detalle de la factura
                                             */
                                            ResultSet rset = con.consulta("SELECT U.F_NomCli,DATE_FORMAT(F.F_FecEnt,'%d/%m/%Y') AS F_FecEnt,F.F_ClaDoc,F.F_ClaPro,M.F_DesPro,L.F_ClaLot,DATE_FORMAT(L.F_FecCad,'%d/%m/%Y') AS F_FecCad,F.F_CantReq,F.F_CantSur,F.F_Costo,F.F_Monto, F.F_Ubicacion, F.F_IdFact, F.F_StsFact, F.F_Obs FROM tb_factura F INNER JOIN tb_medica M ON F.F_ClaPro=M.F_ClaPro INNER JOIN tb_lote L ON F.F_Lote=L.F_FolLot INNER JOIN tb_uniatn U ON F.F_ClaCli=U.F_ClaCli WHERE F.F_ClaDoc='" + request.getParameter("fol_gnkl") + "' GROUP BY F.F_IdFact");
                                            while (rset.next()) {
                                %>
                                <tr>
                                    <td><%=rset.getString(4)%></td>
                                    <td><%=rset.getString(5)%></td>
                                    <td><%=rset.getString(6)%></td>
                                    <td><%=rset.getString(7)%></td>
                                    <td><%=rset.getString(8)%></td>
                                    <td><%=rset.getString(12)%></td>
                                    <td><%=rset.getString(9)%></td>
                                    <td><%=rset.getString(10)%></td>
                                    <td><%=rset.getString(11)%></td>
                                    <td align="center">
                                        <%
                                            if (rset.getString("F_StsFact").equals("A")) {
                                        %>
                                        <!--
                                        Manda llamar al modal referente al id
                                        -->
                                        <a class="btn btn-block btn-danger" data-toggle="modal" data-target="#Devolucion<%=rset.getString("F_IdFact")%>"><span class="glyphicon glyphicon-remove-circle"></span></a>
                                        <input class="checkbox-inline" value="<%=rset.getString("F_IdFact")%>" onchange="Pruebachk(this,<%=request.getParameter("fol_gnkl")%>)" type="checkbox" id="chkDev" name="chkDev">
                                        <%
                                        } else {
                                        %>
                                        <a href="#" title="<%=rset.getString("F_Obs")%>">Observaciones</a>
                                        <%
                                            }
                                        %>
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
                        <div align="right">
                            <a class="btn btn-warning disabled" id="devolVarias" data-toggle="modal" data-target="#DevolucionMultiple">Devolver Varias</a>
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
                Modal
        -->
        <div id="DevolucionMultiple" class="modal fade in" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <a data-dismiss="modal" class="close">×</a>
                        <h3>Devolución Multiple</h3>
                    </div>
                    <div class="modal-body">
                        <div class="panel panel-body">
                            <table id="tbDev">
                                <tr><td>
                                        <%=sesion.getAttribute("list")%>
                                    </td></tr>
                            </table>
                            <div class="row h4">
                                Observaciones
                            </div>
                            <div class="row">
                                <div class="col-sm-12">
                                    <textarea name="ObserM" id="ObserM" class="form-control"></textarea>
                                </div>
                            </div>
                            <div class="row h4">
                                Contraseña
                            </div>
                            <div class="row">
                                <div class="col-sm-12">
                                    <input name="ContraDevoM" id="ContraDevoM" class="form-control" type="password" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary disabled" id="devM" onclick="return validaDevolucionM();" name="devM" value="Devolución">Devolver</button>
                        <a href="#" data-dismiss="modal" class="btn btn-primary">Cerrar</a>
                    </div>
                </div>
            </div>                
        </div> 
        <%
            try {
                con.conectar();
                try {
                    ResultSet rset = con.consulta("SELECT U.F_NomCli,DATE_FORMAT(F.F_FecEnt,'%d/%m/%Y') AS F_FecEnt,F.F_ClaDoc,F.F_ClaPro,M.F_DesPro,L.F_ClaLot,DATE_FORMAT(L.F_FecCad,'%d/%m/%Y') AS F_FecCad,F.F_CantReq,F.F_CantSur,F.F_Costo,F.F_Monto, F.F_Ubicacion, F.F_IdFact FROM tb_factura F INNER JOIN tb_medica M ON F.F_ClaPro=M.F_ClaPro INNER JOIN tb_lote L ON F.F_Lote=L.F_FolLot INNER JOIN tb_uniatn U ON F.F_ClaCli=U.F_ClaCli WHERE F.F_ClaDoc='" + request.getParameter("fol_gnkl") + "' GROUP BY F.F_IdFact");
                    while (rset.next()) {
        %>
        <!--
        Generación de cada uno de los modales que se mandaran llamar
        -->
        <div class="modal fade" id="Devolucion<%=rset.getString("F_IdFact")%>" tabindex="-1" role="dialog" aria-labelledby="basicModal" aria-hidden="true">
            <div class="modal-dialog">
                <form action="FacturacionManual">
                    <div class="modal-content">
                        <div class="modal-header">
                            <div class="row">
                                <div class="col-sm-5">
                                    Devolución:
                                </div>
                            </div>
                        </div>
                        <div class="modal-body">
                            <input id="IdFact" name="IdFact" value="<%=rset.getString("F_IdFact")%>" class="hidden">
                            <div class="row">
                                <div class="col-sm-12">
                                    <div class="col-sm-3">
                                        Clave: <%=rset.getString("F_ClaPro")%>
                                    </div>
                                    <div class="col-sm-9">
                                        Descripción: <%=rset.getString("F_DesPro")%>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-sm-12">
                                    <h4>Cantidad a Remisionada:<%=rset.getString("F_CantSur")%></h4>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-6">
                                    <h4>Cantidad a a Devolver:</h4>
                                </div>
                                <div class="col-sm-6">
                                    <input class="form-control" value="<%=rset.getString("F_CantSur")%>" name="CantDevolver" />
                                </div>
                            </div>
                            <h4 class="modal-title" id="myModalLabel">Observaciones</h4>
                            <div class="row">
                                <div class="col-sm-12">
                                    <textarea name="Obser" id="Obser<%=rset.getString("F_IdFact")%>" class="form-control"></textarea>
                                </div>
                            </div>
                            <h4 class="modal-title" id="myModalLabel">Contraseña</h4>
                            <div class="row">
                                <div class="col-sm-12">
                                    <input name="ContraDevo<%=rset.getString("F_IdFact")%>" id="ContraDevo<%=rset.getString("F_IdFact")%>" class="form-control" type="password" onkeyup="validaContra(this.id);" />
                                </div>
                            </div>
                            <div style="display: none;" class="text-center" id="Loader">
                                <img src="imagenes/ajax-loader-1.gif" height="150" alt="" />
                            </div>
                            <div class="modal-footer">
                                <button type="submit" class="btn btn-primary" id="<%=rset.getString("F_IdFact")%>" disabled onclick="return validaDevolucion(this.id);" name="accion" value="devolucion">Devolver</button>
                                <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        <%
                    }
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
                con.cierraConexion();
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        %>
        <!--
        /Modal
        -->
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
                                    });
        </script>
        <script type="text/javascript">
            $(function() {
                $("#fecha").datepicker();
                $("#fecha").datepicker('option', {dateFormat: 'dd/mm/yy'});
            });

            function validaDevolucion(e) {
                /**
                 * 
                 * Para valida que se llenen los datos necesarios
                 */
                var id = e;
                if (document.getElementById('Obser' + id).value === "") {
                    alert("Ingrese las observaciones de la devolución");
                    return false;
                }
            }

            function validaContra(elemento) {
                /**
                 * Valida la contraseña
                 */
                //alert(elemento);
                var pass = document.getElementById(elemento).value;
                var id = elemento.split("ContraDevo");
                if (pass === "rosalino") {
                    //alert(pass);
                    document.getElementById(id[1]).disabled = false;
                    //$(id[1]).prop("disabled", false);
                } else {
                    document.getElementById(id[1]).disabled = true;
                    //$(id[1]).prop("disabled", true);
                }
            }
            $('#ContraDevoM').keyup(function() {
                /*
                 * Valida contraseña 
                 */
                if ($('#ContraDevoM').val() === "rosalino") {
                    $('#devM').removeClass("disabled");
                } else {
                    $('#devM').addClass("disabled");
                }
            });
            $('#devM').click(function() {
                /**
                 * Aplicar devoluciones multiples
                 */
                if (document.getElementById('ObserM').value === "") {
                    alert("Ingrese las observaciones de la devolución");
                    return false;
                }
                var dir = "DevolucionMultiple";
                var ObserM = $('#ObserM').val();
                $.ajax({
                    url: dir,
                    data: {que: "g", ObserM: ObserM},
                    success: function(data) {
                        if (data !== "no") {
                            var dataArray = data.split("|");
                            alert('Devoluciones Exitosas\n' + dataArray[1]);
                            window.location.reload();
                        } else {
                            alert('Error al Realizar las Devoluciones');
                            window.location.reload();
                        }
                    },
                    error: function() {
                        alert('Error al Realizar las Devoluciones');
                        window.location.href = 'devolucionesFacturas.jsp';
                    }
                });
            });
            function Pruebachk(chk, folio) {
                /**
                 * Seleccionar multiples facturas a devolver
                 */
                if (chk.checked === true) {
                    var id = chk.value;
                    var dir = "DevolucionMultiple";
                    $.ajax({
                        url: dir,
                        data: {que: "add", id: id, folio: folio},
                        success: function(data) {
                            $('#devolVarias').removeClass("disabled");
                            $('#tbDev').load('devolucionesFacturas.jsp #tbDev');
                        },
                        error: function() {
                            alert("Ocurrió un error");
                        }
                    });
                } else {
                    var id = chk.value;
                    var dir = "DevolucionMultiple";
                    $.ajax({
                        url: dir,
                        data: {que: "rem", id: id, folio: folio},
                        success: function(data) {
                            $('#tbDev').load('devolucionesFacturas.jsp #tbDev');
                        },
                        error: function() {
                            alert("Ocurrió un error");
                        }
                    });
                }
            }
        </script>
    </body>
</html>