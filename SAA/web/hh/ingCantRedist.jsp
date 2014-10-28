<%-- 
    Document   : insumoNuevoRedist
    Created on : 6/10/2014, 10:49:37 AM
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
    DecimalFormatSymbols custom = new DecimalFormatSymbols();
    custom.setDecimalSeparator('.');
    custom.setGroupingSeparator(',');
    formatter.setDecimalFormatSymbols(custom);
    HttpSession sesion = request.getSession();
    String usua = "";
    String tipo = "";
    if (sesion.getAttribute("nombre") != null) {
        usua = (String) sesion.getAttribute("nombre");
        tipo = (String) sesion.getAttribute("Tipo");
    } else {
        response.sendRedirect("../index.jsp");
    }
    ConectionDB con = new ConectionDB();

    String idLote = "";
    try {
        idLote = request.getParameter("idLote");
    } catch (Exception e) {

    }
    if (idLote == null) {
        idLote = "";
    }
    String ClaPro = "", UbiAnt = "";
    try {
        ClaPro = request.getParameter("ClaPro");
        UbiAnt = request.getParameter("UbiAnt");
    } catch (Exception e) {
    }

    if (ClaPro == null) {
        ClaPro = "";
    }
    if (UbiAnt == null) {
        UbiAnt = "";
    }
    try {
        con.conectar();
        ResultSet rset = con.consulta("select F_Ubica from tb_lote where F_IdLote='" + idLote + "'");
        while (rset.next()) {
        UbiAnt=rset.getString(1);
        }
        con.cierraConexion();
    } catch (Exception e) {

    }
%>
<html>
    <head>
        <!-- Estilos CSS -->
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="../css/bootstrap.css" rel="stylesheet">
        <link href="../css/datepicker3.css" rel="stylesheet">
        <link rel="stylesheet" href="../css/cupertino/jquery-ui-1.10.3.custom.css" />
        <link href="../css/navbar-fixed-top.css" rel="stylesheet">
        <!---->
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SIE Sistema de Ingreso de Entradas</title>
    </head>
    <body>
        <div class="container">
            <h1>SIALSS</h1>
            <div class="navbar navbar-default">
                <div class="container">
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                            <span clss="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                        <a class="navbar-brand" href="../main_menu.jsp">Inicio</a>
                    </div>
                    <div class="navbar-collapse collapse">
                        <ul class="nav navbar-nav">
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Entradas<b class="caret"></b></a>
                                <ul class="dropdown-menu">
                                    <%
                                        if (tipo.equals("2") || tipo.equals("3") || tipo.equals("1")) {
                                    %>

                                    <li><a href="../captura.jsp">Entrada Manual</a></li>
                                    <li><a href="../compraAuto2.jsp">Entrada Automática OC ISEM</a></li>
                                    <li class="divider"></li>
                                    <li><a href="compraAuto3.jsp">HANDHELD | Entrada Automática OC ISEM</a></li>
                                    <li class="divider"></li>
                                        <%
                                            }
                                            if (tipo.equals("2") || tipo.equals("3")) {
                                        %>
                                    <li><a href="../verificarCompraAuto.jsp">Verificar OC</a></li>
                                        <%
                                            }
                                        %>
                                    <li><a href="#" onclick="window.open('../reimpresion.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Reimpresión de Compras</a></li>
                                    <li><a href="#"  onclick="window.open('../ordenesCompra.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Órdenes de Compras</a></li>
                                    <li><a href="#"  onclick="window.open('../kardexClave.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Kardex Claves</a></li>
                                    <li><a href="#"  onclick="window.open('../Ubicaciones/Consultas.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Ubicaciones</a></li>
                                    <li><a href="#"  onclick="window.open('../creaMarbetes.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Generar Marbetes</a></li>
                                    
                                        <%
                                            if (tipo.equals("5") || tipo.equals("3")) {
                                        %>
                                    <li class="divider"></li>
                                    <li><a href="insumoNuevoRedist.jsp">Redistribución HH</a></li>
                                    <li class="divider"></li>
                                        <%
                                            }
                                        %>
                                        <%
                                            if (usua.equals("oscar")) {
                                        %>
                                    <li class="divider"></li>
                                    <li><a href="#"  onclick="window.open('../devolucionesInsumo.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Cambio Físico</a></li>
                                    <li class="divider"></li>
                                        <%
                                            }
                                        %>
                                    <li><a href="#"  onclick="window.open('../Ubicaciones/index_Marbete.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Marbete de Salida</a></li>
                                    <li><a href="#"  onclick="window.open('../Ubicaciones/index_Marbete_resto.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Marbete de Resto</a></li>
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
                                    <li><a href="../requerimiento.jsp">Carga de Requerimiento</a></li>
                                    <li><a href="../factura.jsp">Facturación Automática</a></li>
                                        <%
                                            }
                                        %>
                                        <%
                                            if (tipo.equals("5") || tipo.equals("3") || tipo.equals("7")) {
                                        %>
                                    <li><a href="../validacionSurtido.jsp">Validación Surtido</a></li>
                                    <li><a href="../validacionAuditores.jsp">Validación Auditores</a></li>
                                        <%
                                            }
                                        %>
                                        <%
                                            if (tipo.equals("7")) {
                                        %>
                                    <li><a href="../remisionarCamion.jsp">Generar Remisiones</a></li>
                                    <li><a href="../facturacionManual.jsp">Facturación Manual</a></li>
                                        <%
                                            }
                                        %>
                                    <li><a href="../reimp_factura.jsp">Administrar Remisiones</a></li>
                                    <li><a href="../reimpConcentrado.jsp">Reimpresión Concentrados Globales</a></li>
                                    <li><a href="../comparativoGlobal.jsp">Comparativo Global</a></li>

                                </ul>
                            </li>
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Inventario<b class="caret"></b></a>
                                <ul class="dropdown-menu">
                                    <li><a href="#"  onclick="window.open('../Ubicaciones/Inventario.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Inventario</a></li>
                                        <%
                                            if (tipo.equals("5") || tipo.equals("3") || tipo.equals("7")) {
                                        %>
                                    <li><a href="#"  onclick="window.open('../movimientosUsuarioInventario.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Movimientos por Usuario</a></li>
                                    <li><a href="#"  onclick="window.open('../semaforo.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Semaforización</a></li>
                                        <%
                                            }
                                        %>
                                    <li><a href="#"  onclick="window.open('../invenCiclico/nuevoInventario.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Inventario Ciclico</a></li>
                                </ul>
                            </li>
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Catálogos<b class="caret"></b></a>
                                <ul class="dropdown-menu">
                                    <li><a href="#" onclick="window.open('../medicamento.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Catálogo de Medicamento</a></li>
                                    <li><a href="#" onclick="window.open('../catalogo.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Catálogo de Proveedores</a></li>
                                    <li><a href="#" onclick="window.open('../marcas.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Catálogo de Marcas</a></li>
                                </ul>
                            </li>
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Reportes<b class="caret"></b></a>
                                <ul class="dropdown-menu">
                                    <li><a href="#" onclick="window.open('../Entrega.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Fecha de Recibo en CEDIS</a></li> 
                                    <li><a href="#" onclick="window.open('../historialOC.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Historial OC</a></li>
                                    <li><a href="#" onclick="window.open('../ReporteF.jsp', '', 'width=1200,height=800,left=50,top=50,toolbar=no')">Reporte por Fecha Proveedor</a></li>

                                </ul>
                            </li>
                        </ul>
                        <ul class="nav navbar-nav navbar-right">
                            <li><a href="#"><span class="glyphicon glyphicon-user"></span> <%=usua%></a></li>
                            <li class="active"><a href="../index.jsp"><span class="glyphicon glyphicon-log-out"></span></a></li>
                        </ul>
                    </div><!--/.nav-collapse -->
                </div>
            </div>
            <h4>Redistribución</h4>
            <form action="leerInsRedist.jsp" method="post">
                <input class="hidden" name="UbiAnt" value="<%=UbiAnt%>" />
                <input class="hidden" name="ClaPro" value="<%=ClaPro%>" />
                <button class="btn btn-default" type="submit">Regresar</button>
            </form>
            <%
                try {
                    int canApartada = 0;
                    con.conectar();
                    ResultSet rset = con.consulta("select u.F_DesUbi, l.F_ClaPro, l.F_ExiLot, m.F_DesPro, l.F_ClaLot, DATE_FORMAT(l.F_FecCad, '%d/%m/%Y') as F_FecCad, l.F_IdLote, u.F_ClaUbi, u.F_Cb as CbUbica from tb_lote l, tb_medica m, tb_ubica u where l.F_ClaPro = m.F_ClaPro AND l.F_Ubica = u.F_ClaUbi and l.F_ExiLot!=0 and l.F_IdLote = '" + idLote + "' ");
                    while (rset.next()) {
                        int banAlerta = 0;
                        ResultSet rset2 = con.consulta("select F_IdLot, SUM(F_Cant) from tb_facttemp where F_IdLot = '" + idLote + "' and F_StsFact <5 group by F_IdLot");
                        while (rset2.next()) {
                            banAlerta = 1;
                            canApartada = rset2.getInt(2);
                        }
            %>
            <form action="../Ubicaciones">
                <h5>
                    Ubicación: <%=rset.getString("F_DesUbi")%>
                    <br/>
                    Clave: <%=rset.getString("F_ClaPro")%>
                    <br/>
                    Cantidad: <%=formatter.format(rset.getInt("F_ExiLot"))%>
                    <input name="CantAnt" id="CantAnt" class="hidden" value="<%=(rset.getInt("F_ExiLot") - canApartada)%>" />
                    <br/>
                    Descripción: <%=rset.getString("F_DesPro")%>
                    <br/>
                    Lote: <%=rset.getString("F_ClaLot")%>
                    <br/>
                    Caducidad: <%=rset.getString("F_FecCad")%>
                    <br/>
                </h5>
                <div class="row">
                    <h5 class="col-lg-12">Cantidad a Mover:</h5>
                    <div class="col-lg-12">
                        <input class="form-control" placeholder="Cantidad a Mover" type="number" name="CantMov" id="CantMov" min="1" max="<%=(rset.getInt("F_ExiLot") - canApartada)%>" />
                    </div>
                </div>
                <div class="row">
                    <h5 class="col-lg-12">CB de Nueva Ubicación:</h5>
                    <div class="col-lg-12">
                        <input class="form-control" id="F_ClaUbi" name="F_ClaUbi" placeholder="CB de Nueva Ubicación" type="text" />
                        <input class="hidden" id="F_IdLote" name="F_IdLote" value="<%=idLote%>" />
                        <input id="aClaUbi" class="hidden" value="<%=rset.getString("F_ClaUbi")%>"/>
                        <input id="aCbUbica" class="hidden" value="<%=rset.getString("CbUbica")%>"/>
                    </div>
                </div>
                <br/>
                <%
                    if (banAlerta == 1) {
                %>
                <div class="alert alert-danger">
                    <strong>Este insumo está apartado con <%=canApartada%> piezas</strong>
                </div>
                <div class="alert alert-warning">
                    <strong>Cantidad máxima a mover: <%=(rset.getInt("F_ExiLot") - canApartada)%> piezas</strong>
                </div>
                <%
                    }
                %>
                <div class="row">
                    <div class="col-lg-12">
                        <button class="btn btn-block btn-primary btn-lg" onclick="return validaRedist();" name="accion" value="Redistribucion">Redistribuir</button>
                    </div>
                </div>
            </form>
            <%
                    }
                    con.cierraConexion();
                } catch (Exception e) {

                }
            %>
        </div>

    </body>
    <!-- 
================================================== -->
    <!-- Se coloca al final del documento para que cargue mas rapido -->
    <!-- Se debe de seguir ese orden al momento de llamar los JS -->

    <script src="../js/jquery-1.9.1.js"></script>
    <script src="../js/bootstrap.js"></script>
    <script src="../js/jquery-ui-1.10.3.custom.js"></script>
    <script src="../js/bootstrap-datepicker.js"></script>
    <script src="../js/funcRedistribucion.js"></script>
</html>
