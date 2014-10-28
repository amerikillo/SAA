<%-- 
    Document   : index
    Created on : 17/02/2014, 03:34:46 PM
    Author     : Americo
--%>

<%@page import="java.util.Date"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.DecimalFormatSymbols"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="conn.*" %>
<!DOCTYPE html>
<%java.text.DateFormat df = new java.text.SimpleDateFormat("yyyyMMddhhmmss"); %>
<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%java.text.DateFormat df3 = new java.text.SimpleDateFormat("dd/MM/yyyy"); %>
<%java.text.DateFormat df1 = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%
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
    String vOrden = "", vRemi = "";

    try {
        vOrden = (String) sesion.getAttribute("vOrden");
        vRemi = (String) sesion.getAttribute("vRemi");
    } catch (Exception e) {
    }

    try {
        String Folio = "";
        String folio[] = null;
        Folio = request.getParameter("NoCompra");
        if (!Folio.equals("")) {
            folio = Folio.split(",");
            sesion.setAttribute("vOrden", folio[0]);
            sesion.setAttribute("vRemi", folio[1]);
            vOrden = folio[0];
            vRemi = folio[1];
        }
    } catch (Exception e) {
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Estilos CSS -->
        <link href="css/bootstrap.css" rel="stylesheet">
        <link href="css/datepicker3.css" rel="stylesheet">
        <link rel="stylesheet" href="css/cupertino/jquery-ui-1.10.3.custom.css" />
        <link href="css/navbar-fixed-top.css" rel="stylesheet">
        <!---->
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
                                            if (tipo.equals("2") || tipo.equals("3")) {
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
                                            if (tipo.equals("5") || tipo.equals("3") || tipo.equals("7")) {
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
                                            if (tipo.equals("5") || tipo.equals("3") || tipo.equals("7")) {
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
            <form action="verificarCompraAuto.jsp" method="get">
                <br/>
                <div class="row">
                    <label class="col-sm-2">
                        <h4>&Oacute;rdenes de Compra: </h4>
                    </label>
                    <div class="col-sm-9">
                        <select class="form-control" name="NoCompra" onchange="this.form.submit();">
                            <option value="">-- Proveedor -- Orden de Compra --</option>
                            <%                                try {
                                    con.conectar();
                                    ResultSet rset = con.consulta("SELECT c.F_OrdCom, p.F_NomPro, c.F_FolRemi FROM tb_compratemp c, tb_proveedor p WHERE c.F_Provee = p.F_ClaProve and c.F_Estado = '2' GROUP BY c.F_OrdCom, c.F_FolRemi");
                                    while (rset.next()) {
                            %>
                            <option value="<%=rset.getString(1)%>,<%=rset.getString(3)%>"><%=rset.getString(2)%> - <%=rset.getString(1)%> - <%=rset.getString(3)%></option>
                            <%
                                    }
                                    con.cierraConexion();
                                } catch (Exception e) {

                                }
                            %>
                        </select>
                    </div>
                </div>
                <br/>
            </form>
        </div>
        <div style="width: 90%; margin: auto;">
            <br/>

            <div class="panel panel-default">
                <div class="panel-heading">
                    <form action="CompraAutomatica" method="get" name="formulario1">
                        <%
                            try {
                                con.conectar();
                                ResultSet rset = con.consulta("select i.F_NoCompra, DATE_FORMAT(i.F_FecSur, '%d/%m/%Y') as F_FecSur, i.F_HorSur, p.F_NomPro, p.F_ClaProve from tb_pedidoisem i, tb_proveedor p where i.F_Provee = p.F_ClaProve and F_StsPed = '1' and F_NoCompra = '" + vOrden + "'  and F_recibido='0' group by F_NoCompra");
                                while (rset.next()) {
                        %>
                        <div class="row">
                            <h4 class="col-sm-2">Folio Orden de Compra:</h4>
                            <div class="col-sm-2"><input class="form-control" value="<%=vOrden%>" readonly="" name="folio" id="folio" onkeypress="return tabular(event, this)" /></div>
                            <h4 class="col-sm-1">Remisión:</h4>
                            <div class="col-sm-2"><input class="form-control" value="<%=vRemi%>" readonly="" name="folio" id="folio" onkeypress="return tabular(event, this)" /></div>
                        </div>
                        <div class="row">
                            <h4 class="col-sm-12">Proveedor: <%=rset.getString("p.F_NomPro")%></h4>
                        </div>
                        <div class="row">
                            <h4 class="col-sm-9">Fecha y Hora de Entrega: <%=rset.getString("F_FecSur")%> <%=rset.getString("i.F_HorSur")%></h4>
                            <div class="col-sm-2">
                                <a class="btn btn-default" href="compraAuto2.jsp">Agregar Clave al Inventario</a>
                            </div>
                        </div>
                        <%
                                }
                                con.cierraConexion();
                            } catch (Exception e) {
                                e.getMessage();
                            }
                        %>
                    </form>
                </div>
                <div class="panel-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-striped">
                            <tr>
                                <td>Remisión</td>
                                <td>Código de Barras</td>
                                <td>Clave</td>
                                <td>Descripción</td>                       
                                <td>Lote</td>
                                <td>Caducidad</td>                        
                                <td>Cantidad</td>                      
                                <td>Costo U</td>                     
                                <td>IVA</td>                       
                                <td>Importe</td>
                                <td>Observaciones</td>
                                <td></td>
                            </tr>
                            <%
                                int banBtn = 0;
                                try {
                                    con.conectar();
                                    ResultSet rset = con.consulta("SELECT C.F_Cb,C.F_ClaPro,M.F_DesPro,C.F_Lote,C.F_FecCad,C.F_Pz,F_IdCom, C.F_Costo, C.F_ImpTo, C.F_ComTot, C.F_FolRemi, C.F_Obser FROM tb_compratemp C INNER JOIN tb_medica M ON C.F_ClaPro=M.F_ClaPro WHERE F_OrdCom='" + vOrden + "' and F_FolRemi = '" + vRemi + "'  and F_Estado = '2'");
                                    while (rset.next()) {
                                        banBtn = 1;
                            %>
                            <tr>
                                <td><%=rset.getString("C.F_FolRemi")%></td>
                                <td><%=rset.getString(1)%></td>
                                <td><%=rset.getString(2)%></td>
                                <td><%=rset.getString(3)%></td>
                                <td><%=rset.getString(4)%></td>
                                <td><%=df3.format(df2.parse(rset.getString(5)))%></td>
                                <td><%=formatter.format(rset.getDouble(6))%></td>           
                                <td><%=formatterDecimal.format(rset.getDouble("C.F_Costo"))%></td>
                                <td><%=formatterDecimal.format(rset.getDouble("C.F_ImpTo"))%></td>          
                                <td><%=formatterDecimal.format(rset.getDouble("C.F_ComTot"))%></td>   
                                <td><%=rset.getString("C.F_Obser")%></td>
                                <td>
                                    <form method="get" action="Modificaciones">
                                        <input name="id" type="text" style="" class="hidden" value="<%=rset.getString(7)%>" />
                                        <button class="btn btn-warning" name="accion" value="modificarVerifica"><span class="glyphicon glyphicon-pencil" ></span></button>
                                        <button class="btn btn-danger" onclick="return confirm('¿Seguro de que desea eliminar?');" name="accion" value="eliminarVerifica"><span class="glyphicon glyphicon-remove"></span></button>
                                    </form>
                                </td>
                            </tr>
                            <%
                                    }
                                    con.cierraConexion();
                                } catch (Exception e) {

                                }

                            %>
                            <tr>
                                <td colspan="12">

                                </td>
                            </tr>

                        </table>
                    </div>
                    <hr/>
                </div>
                <%                                if (banBtn == 1) {
                %>

                <div class="panel-body table-responsive">
                    <div class="row">
                        <form action="nuevoAutomaticaLotes" method="post">
                            <input name="vOrden" type="text" style="" class="hidden" value='<%=vOrden%>' />
                            <input name="vRemi" type="text" style="" class="hidden" value='<%=vRemi%>' />
                            <div class="col-lg-3 col-lg-offset-3">
                                <button  value="EliminarVerifica" name="accion" class="btn btn-danger btn-block" onclick="return confirm('Seguro que desea eliminar la compra?');">Cancelar Remisión</button>
                            </div>
                            <div class="col-lg-3">
                                <button  value="GuardarAbiertaVerifica" name="accion" class="btn btn-warning  btn-block" onclick="return confirm('Seguro que desea realizar la compra?');
                                        return validaCompra();">Remisión Abierta</button>
                            </div>
                            <div class="col-lg-3">
                                <button  value="GuardarVerifica" name="accion" class="btn btn-success  btn-block" onclick="return confirm('Seguro que desea realizar la compra?');
                                        return validaCompra();">Confirmar Remisión</button>
                            </div>
                        </form>
                    </div>
                </div>
                <%
                    }
                %>

                <!--div class="panel-footer">
                    <button class="btn btn-block btn-success btn-lg" name="accion" id="accion" value="confirmar" onclick="return validaCompra();">Confirmar Compra</button>
                </div-->
            </div>
        </div>


        <br><br><br>
        <div class="navbar navbar-inverse">
            <div class="text-center text-muted">
                GNK Logística || Desarrollo de Aplicaciones 2009 - 2014 <span class="glyphicon glyphicon-registration-mark"></span><br />
                Todos los Derechos Reservados
            </div>
        </div>


        <!--
        Modal
        -->
        <div class="modal fade" id="Rechazar" tabindex="-1" role="dialog" aria-labelledby="basicModal" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <form action="Rechazos" method="get">
                        <div class="modal-header">
                            <div class="row">
                                <div class="col-sm-5">
                                    <h4 class="modal-title" id="myModalLabel">Rechazar Orden de Compra</h4>
                                </div>
                                <div class="col-sm-2">
                                    <input name="NoCompraRechazo" id="NoCompraRechazo" value="" class="form-control" readonly="" />
                                </div>
                            </div>
                            <div class="row">

                                <div class="col-sm-12">
                                    Proveedor:
                                </div>
                                <div class="col-sm-12">
                                    Fecha y Hora 
                                </div>
                            </div>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-sm-12">
                                    <h4>Observaciones de Rechazo</h4>
                                </div>
                                <div class="col-sm-12">
                                    <textarea class="form-control" placeholder="Observaciones" name="rechazoObser" id="rechazoObser" rows="5"></textarea>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-12">
                                    <h4>Fecha de nueva recepción</h4>
                                </div>
                                <div class="col-sm-6">
                                    <input type="date" min="" class="form-control" id="FechaOrden" name="FechaOrden" />
                                </div>
                                <div class="col-sm-6">
                                    <select class="form-control" id="HoraOrden" name="HoraOrden">
                                        <option value=":00">:00</option>
                                        <option value=":30">:30</option>
                                        <option value=":00">:00</option>
                                    </select>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-sm-12">
                                    <h4>Correo del proveedor</h4>
                                    <input type="email" class="form-control" id="correoProvee" name="correoProvee" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-6">
                                    <h4>Claves a Cancelar</h4>
                                    <h6>*Deseleccione las claves que no va a cancelar</h6>
                                </div>
                                <div class="col-sm-6">
                                    <div class="checkbox">
                                        <label>
                                            <h4><input type="checkbox" checked name="todosChk" id="todosChk" onclick="checkea(this)">Seleccionar todas</h4>
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-12">
                                    <table class="table table-bordered">

                                        <tr>

                                            <td>
                                                <div class="checkbox">
                                                    <label>
                                                        <input type="checkbox" checked="" name="chkCancela" value="">
                                                    </label>
                                                </div>
                                            </td>

                                        </tr>

                                    </table>
                                </div>
                            </div>
                            <div class="text-center" id="imagenCarga" style="display: none;" > 
                                <img src="imagenes/ajax-loader-1.gif">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-primary" onclick="return validaRechazo();
                                    " name="accion" value="Rechazar">Rechazar OC</button>
                            <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                        </div>
                    </form>
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
    <script src="js/bootstrap-datepicker.js"></script>
    <script type="text/javascript">

    </script>

</html>
