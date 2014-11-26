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
    DecimalFormat formatter = new DecimalFormat("#,###,###");
    DecimalFormat formatterDecimal = new DecimalFormat("#,###,##0.00");
    DecimalFormatSymbols custom = new DecimalFormatSymbols();
    custom.setDecimalSeparator('.');
    custom.setGroupingSeparator(',');
    formatter.setDecimalFormatSymbols(custom);
    formatterDecimal.setDecimalFormatSymbols(custom);
    HttpSession sesion = request.getSession();
    String usua = "", tipo = "";
    if (sesion.getAttribute("nombre") != null) {
        usua = (String) sesion.getAttribute("nombre");
        tipo = (String) sesion.getAttribute("Tipo");
    } else {
        response.sendRedirect("index.jsp");
    }
    ConectionDB con = new ConectionDB();
    String Clave = "", Fecha = "";

    try {
        Clave = request.getParameter("Nombre");
    } catch (Exception e) {

    }
    if (Clave == null) {
        try {
            Clave = (String) sesion.getAttribute("Nombre");
            if (Clave == null) {
                Clave = "";
            }
        } catch (Exception e) {
            Clave = "";
        }
    }
    if (Clave == null) {
        Clave = "";
    }
    try {
        con.conectar();
        con.insertar("update tb_facttemp set F_StsFact='4', F_User ='" + usua + "' where F_Id = '" + request.getParameter("CB") + "' and F_StsFact = '2'");

        ResultSet rset = con.consulta("select F_FecEnt from tb_facttemp where F_Id = '" + request.getParameter("CB") + "'");
        while (rset.next()) {
            Fecha = rset.getString(1);
        }
        con.cierraConexion();
    } catch (Exception e) {

    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Estilos CSS -->
        <link href="css/bootstrap.css" rel="stylesheet">
        <link rel="stylesheet" href="css/cupertino/jquery-ui-1.10.3.custom.css" />
        <link href="css/navbar-fixed-top.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="css/dataTables.bootstrap.css">
        <!---->
        <title>SIALSS</title>
    </head>
    <body>
        <div class="container">
            <h1>SIALSS</h1>
            <h4>Módulo - Sistema de Administración de Almacenes (SAA)</h4>
            <div class="navbar navbar-default">
                <div class="container">
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                            <span clss="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                        <a class="navbar-brand" href="main_menu.jsp">Inicio</a>
                    </div>
                    <div class="navbar-collapse collapse">
                        <ul class="nav navbar-nav">
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Entradas<b class="caret"></b></a>
                                <ul class="dropdown-menu">
                                    <%
                                        if (tipo.equals("2") || tipo.equals("3") || tipo.equals("1")) {
                                    %>

                                    <li><a href="captura.jsp">Entrada Manual</a></li>
                                    <li><a href="compraAuto2.jsp">Entrada Automática OC ISEM</a></li>
                                    <li class="divider"></li>
                                    <li><a href="hh/compraAuto3.jsp">HANDHELD | Entrada Automática OC ISEM</a></li>
                                    <li class="divider"></li>
                                        <%
                                            }
                                            if (tipo.equals("2") || tipo.equals("3") || tipo.equals("5")) {
                                        %>
                                    <li><a href="verificarCompraAuto.jsp">Verificar OC</a></li>
                                        <%
                                            }
                                        %>
                                    <li><a href="#" onclick="window.open('reimpresion.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Reimpresión de Compras</a></li>
                                    <li><a href="#"  onclick="window.open('ordenesCompra.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Órdenes de Compras</a></li>
                                    <li><a href="#"  onclick="window.open('kardexClave.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Kardex Claves</a></li>
                                    <li><a href="#"  onclick="window.open('Ubicaciones/Consultas.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Ubicaciones</a></li>
                                    <li><a href="#"  onclick="window.open('creaMarbetes.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Generar Marbetes</a></li>
                                    
                                        <%
                                            if (tipo.equals("5") || tipo.equals("3")) {
                                        %>
                                    <li class="divider"></li>
                                    <li><a href="hh/insumoNuevoRedist.jsp">Redistribución HH</a></li>
                                    <li class="divider"></li>
                                        <%
                                            }
                                        %>
                                        <%
                                            if (usua.equals("oscar")) {
                                        %>
                                    <li class="divider"></li>
                                    <li><a href="#"  onclick="window.open('devolucionesInsumo.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Cambio Físico</a></li>
                                    <li class="divider"></li>
                                        <%
                                            }
                                        %>
                                    <li><a href="#"  onclick="window.open('Ubicaciones/index_Marbete.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Marbete de Salida</a></li>
                                    <li><a href="#"  onclick="window.open('Ubicaciones/index_Marbete_resto.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Marbete de Resto</a></li>
                                    <!--li><a href="#"  onclick="window.open('verDevolucionesEntrada.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Imprimir Devoluciones</a></li>
                                    <li><a href="#"  onclick="window.open('devolucionesInsumo.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Devolver</a></li-->
                                </ul>
                            </li>
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Facturación<b class="caret"></b></a>
                                <ul class="dropdown-menu">
                                    <%
                                        if (tipo.equals("7") || tipo.equals("3")) {
                                    %>
                                    <li><a href="requerimiento.jsp">Carga de Requerimiento</a></li>
                                    <li><a href="factura.jsp">Facturación Automática</a></li>
                                        <%
                                            }
                                        %>
                                        <%
                                           if (tipo.equals("5") || tipo.equals("3") || tipo.equals("7") || tipo.equals("2")) {
                                        %>
                                    <li><a href="validacionSurtido.jsp">Validación Surtido</a></li>
                                    <li><a href="validacionAuditores.jsp">Validación Auditores</a></li>
                                        <%
                                            }
                                        %>
                                        <%
                                            if (tipo.equals("7")) {
                                        %>
                                    <li><a href="remisionarCamion.jsp">Generar Remisiones</a></li>
                                    <li><a href="facturacionManual.jsp">Facturación Manual</a></li>
                                        <%
                                            }
                                        %>
                                    <li><a href="reimp_factura.jsp">Administrar Remisiones</a></li>
                                    <li><a href="reimpConcentrado.jsp">Reimpresión Concentrados Globales</a></li>
                                    <li><a href="comparativoGlobal.jsp">Comparativo Global</a></li>

                                </ul>
                            </li>
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Inventario<b class="caret"></b></a>
                                <ul class="dropdown-menu">
                                    <li><a href="#"  onclick="window.open('Ubicaciones/Inventario.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Inventario</a></li>
                                        <%
                                           if (tipo.equals("5") || tipo.equals("3") || tipo.equals("7") || tipo.equals("2")) {
                                        %>
                                    <li><a href="#"  onclick="window.open('movimientosUsuarioInventario.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Movimientos por Usuario</a></li>
                                    <li><a href="#"  onclick="window.open('semaforo.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Semaforización</a></li>
                                        <%
                                            }
                                        %>
                                    <li><a href="#"  onclick="window.open('invenCiclico/nuevoInventario.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Inventario Ciclico</a></li>
                                </ul>
                            </li>
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Catálogos<b class="caret"></b></a>
                                <ul class="dropdown-menu">
                                    <li><a href="#" onclick="window.open('medicamento.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Catálogo de Medicamento</a></li>
                                    <li><a href="#" onclick="window.open('catalogo.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Catálogo de Proveedores</a></li>
                                    <li><a href="#" onclick="window.open('marcas.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Catálogo de Marcas</a></li>
                                </ul>
                            </li>
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Reportes<b class="caret"></b></a>
                                <ul class="dropdown-menu">
                                    <li><a href="#" onclick="window.open('Entrega.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Fecha de Recibo en CEDIS</a></li> 
                                    <li><a href="#" onclick="window.open('historialOC.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Historial OC</a></li>
                                    <li><a href="#" onclick="window.open('ReporteF.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Reporte por Fecha Proveedor</a></li>

                                </ul>
                            </li>
                        </ul>
                        <ul class="nav navbar-nav navbar-right">
                            <li><a href="#"><span class="glyphicon glyphicon-user"></span> <%=usua%></a></li>
                            <li class="active"><a href="index.jsp"><span class="glyphicon glyphicon-log-out"></span></a></li>
                        </ul>
                    </div><!--/.nav-collapse -->
                </div>
            </div>

            <h3>
                Remisionar por CB
            </h3>
            <div class="panel panel-primary">
                <div class="panel-body">
                    <form method="post" action="remisionarCamion.jsp">
                        <div class="row">
                            <h4 class="col-sm-3">Seleccione el proveedor</h4>
                            <div class="col-sm-5">
                                <select id="Nombre" name="Nombre" class="form-control">
                                    <option value="">Unidad</option>
                                    <%
                                        try {
                                            con.conectar();
                                            ResultSet rset = con.consulta("select u.F_ClaCli, u.F_NomCli from tb_uniatn u, tb_facttemp f where u.F_StsCli = 'A' and f.F_ClaCli = u.F_ClaCli group by u.F_ClaCli");
                                            while (rset.next()) {
                                    %>
                                    <option value="<%=rset.getString(1)%>"
                                            <%
                                                if (Clave.equals(rset.getString(1))) {
                                                    out.println("selected");
                                                }
                                            %>
                                            ><%=rset.getString(2)%></option>
                                    <%
                                            }
                                            con.cierraConexion();
                                        } catch (Exception e) {

                                            System.out.println(e.getMessage());
                                        }
                                    %>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <h4 class="col-sm-3">Capture CB</h4>
                            <div class="col-sm-3">
                                <input class="form-control" name="CB" autofocus=""/>
                            </div>
                            <div class="col-sm-2">
                                <button class="btn btn-block btn-primary" name="accion" value="buscarCB">Buscar</button>
                            </div>
                        </div>
                    </form>
                </div>
                <form action="FacturacionManual" methos="post" name="FormFactura" id="FormFactura">
                    <input name="Nombre" value="<%=Clave%>" class="hidden" />
                    <input name="Fecha" value="<%=Fecha%>" class="hidden" />

                    <div class="panel-footer table-responsive">
                        <table class="table table-bordered table-condensed table-responsive table-striped" id="datosProv">
                            <thead>
                                <tr>
                                    <td></td>
                                    <td>ID</td>
                                    <td>CB</td>
                                    <td>Clave</td>
                                    <td>Lote</td>
                                    <td>Caducidad</td>
                                    <td>Ubicación</td>
                                    <td>Cajas</td>
                                    <td>Resto</td>
                                    <td>Piezas</td>
                                    <td></td>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    int i = 1;
                                    try {
                                        con.conectar();
                                        ResultSet rset = null;
                                        rset = con.consulta("SELECT	u.F_NomCli,	DATE_FORMAT(f.F_FecEnt, '%d/%m/%Y') as Fecha,	l.F_ClaPro,	l.F_ClaLot,	DATE_FORMAT(l.F_FecCad, '%d/%m/%Y') as feccad,	(f.F_Cant+0) as F_Cant,	l.F_Ubica,	f.F_IdFact,	l.F_Cb,	p.F_Pzs,	(f.F_Cant DIV p.F_Pzs) as cajas,	(f.F_Cant MOD p.F_Pzs) as resto, f.F_Id, f.F_IdLot, m.F_DesPro FROM	tb_facttemp f,	tb_lote l,	tb_uniatn u,	tb_pzxcaja p, tb_medica m WHERE l.F_ClaPro = m.F_ClaPro and	f.F_IdLot = l.F_IdLote AND f.F_ClaCli = u.F_ClaCli AND p.F_ClaPro = l.F_ClaPro AND f.F_ClaCli = '" + Clave + "' and f.F_StsFact=4 and f.F_User = '" + (String) sesion.getAttribute("nombre") + "';");
                                        rset.last();
                                        int ren = rset.getRow();
                                        rset.first();
                                        rset = con.consulta("SELECT	u.F_NomCli,	DATE_FORMAT(f.F_FecEnt, '%d/%m/%Y') as Fecha,	l.F_ClaPro,	l.F_ClaLot,	DATE_FORMAT(l.F_FecCad, '%d/%m/%Y') as feccad,	(f.F_Cant+0) as F_Cant,	l.F_Ubica,	f.F_IdFact,	l.F_Cb,	p.F_Pzs,	(f.F_Cant DIV p.F_Pzs) as cajas,	(f.F_Cant MOD p.F_Pzs) as resto, f.F_Id, f.F_IdLot, m.F_DesPro FROM	tb_facttemp f,	tb_lote l,	tb_uniatn u,	tb_pzxcaja p, tb_medica m WHERE l.F_ClaPro = m.F_ClaPro and	f.F_IdLot = l.F_IdLote AND f.F_ClaCli = u.F_ClaCli AND p.F_ClaPro = l.F_ClaPro AND f.F_ClaCli = '" + Clave + "' and f.F_StsFact=4 and f.F_User = '" + (String) sesion.getAttribute("nombre") + "';");
                                        while (rset.next()) {
                                %>
                                <tr>
                                    <td>
                                        <div class="hidden">
                                            <input type="checkbox" checked="" name="chkSeleccciona" value="<%=rset.getString("F_Id")%>">
                                        </div>
                                    </td>
                                    <td><%=ren%></td>
                                    <td><%=rset.getString("F_Cb")%></td>
                                    <td><a href="#" title="<%=rset.getString("F_DesPro")%>"><%=rset.getString("F_ClaPro")%></a></td>
                                    <td><%=rset.getString("F_ClaLot")%></td>
                                    <td><%=rset.getString("feccad")%></td>
                                    <td><%=rset.getString("F_Ubica")%></td>
                                    <td><%=rset.getString("cajas")%></td>
                                    <td><%=rset.getString("resto")%></td>
                                    <td><%=formatter.format(rset.getInt("F_Cant"))%></td>
                                    <td>
                                        <input name="Nombre" value="<%=Clave%>" class="hidden" />
                                        <input name="IdQuitar" value="<%=rset.getString("F_Id")%>" class="hidden" />
                                        <button name="accion" value="quitarInsumo,<%=rset.getString("F_Id")%>" class="btn btn-block btn-danger" onclick="return confirm('Seguro de desea eliminarel insumo?')"><span class="glyphicon glyphicon-remove"></span></button>
                                    </td>
                                </tr>
                                <%
                                            ren--;
                                        }
                                        con.cierraConexion();
                                    } catch (Exception e) {
                                        System.out.println(e.getMessage());
                                    }
                                %>
                            </tbody>
                        </table>

                    </div><div class="row">
                        <div class="col-sm-2 col-sm-offset-4">
                            <button type="submit" class="hidden" name="accion" id="Facturar" value="remisionCamion" onclick="">Remisionar</button>
                            <button type="submit" class="btn btn-primary btn-block" data-toggle="modal" data-target="#Observaciones" name="accion" value="remisionCamion" onclick="">Remisionar</button>
                        </div>
                    </div>
                    <div class="hidden">
                        <textarea id="Obs" name="Obs"></textarea>
                        <input id="F_Req" name="F_Req" />
                    </div>
                </form>
            </div>
        </div>
        <br><br><br>
        <div class="navbar navbar-fixed-bottom navbar-inverse">
            <div class="text-center text-muted">
                GNK Logística || Desarrollo de Aplicaciones 2009 - 2014 <span class="glyphicon glyphicon-registration-mark"></span><br />
                Todos los Derechos Reservados
            </div>
        </div>


        <!--
                Modal
        -->
        <div class="modal fade" id="Observaciones" tabindex="-1" role="dialog" aria-labelledby="basicModal" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <div class="row">
                            <div class="col-sm-5">
                            </div>
                        </div>
                    </div>
                    <div class="modal-body">
                        <h4 class="modal-title" id="myModalLabel">Requerimiento</h4>
                        <div class="row">
                            <div class="col-sm-12">
                                <input name="Requerimiento" id="Requerimiento" class="form-control" />
                            </div>
                        </div>

                        <h4 class="modal-title" id="myModalLabel">Observaciones</h4>
                        <div class="row">
                            <div class="col-sm-12">
                                <textarea name="Obser" id="Obser" class="form-control"></textarea>
                            </div>
                        </div>
                        <div style="display: none;" class="text-center" id="Loader">
                            <img src="imagenes/ajax-loader-1.gif" height="150" />
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-primary" onclick="return validaRemision();" name="accion" value="actualizarCB">Remisionar</button>
                            <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                        </div>
                    </div>
                </div>
            </div>
            <!--
            /Modal
            -->
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
    <script>
                                function validaRemision() {
                                    var seg = confirm('Desea Remisionar este Insumo?');
                                    if (seg == false) {
                                        return false;
                                    } else {
                                        document.getElementById('Loader').style.display = 'block';
                                        var observaciones = document.getElementById('Obser').value;
                                        document.getElementById('Obs').value = observaciones;
                                        var req = document.getElementById('Requerimiento').value;
                                        document.getElementById('F_Req').value = req;

                                        document.getElementById('Facturar').click();
                                    }

                                }
                                /*$(document).ready(function() {
                                 $('#datosProv').dataTable();
                                 });*/

    </script>
</html>

