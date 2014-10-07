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
    if (sesion.getAttribute("nombre") != null) {
        usua = (String) sesion.getAttribute("nombre");
    } else {
        response.sendRedirect("../index.jsp");
    }
    ConectionDB con = new ConectionDB();

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
                                    <li><a href="../captura.jsp">Entrada Manual</a></li>
                                    <li><a href="../compraAuto2.jsp">Entrada Automática OC ISEM</a></li>
                                    <li><a href="../reimpresion.jsp" target="blank_">Reimpresión de Compras</a></li>
                                    <li><a href="../ordenesCompra.jsp" target="blank_">Órdenes de Compras</a></li>
                                    <li><a href="../kardexClave.jsp" target="blank_">Kardex Claves</a></li>
                                    <li><a href="../Ubicaciones/Consultas.jsp" target="blank_">Ubicaciones</a></li>
                                </ul>
                            </li>
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Facturación<b class="caret"></b></a>
                                <ul class="dropdown-menu">
                                    <li><a href="../requerimiento.jsp">Carga de Requerimiento</a></li>
                                    <li><a href="../factura.jsp">Facturación Automática</a></li>
                                    <li><a href="../reimp_factura.jsp">Administrar Remisiones</a></li>
                                </ul>
                            </li>
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Catálogos<b class="caret"></b></a>
                                <ul class="dropdown-menu">
                                    <li><a href="../medicamento.jsp" target="blank_">Catálogo de Medicamento</a></li>
                                    <li><a href="../catalogo.jsp" target="blank_">Catálogo de Proveedores</a></li>
                                    <li><a href="../marcas.jsp" target="blank_">Catálogo de Marcas</a></li>
                                </ul>
                            </li>
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Fecha Recibo<b class="caret"></b></a>
                                <ul class="dropdown-menu">
                                    <li><a href="../Entrega.jsp" target="blank_">Fecha de Recibo en CEDIS</a></li> 
                                    <li><a href="../historialOC.jsp" target="blank_">Historial OC</a></li>                                      
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
                <a class="btn btn-default" href="insumoNuevoRedist.jsp">Regresar</a>
                <button class="btn btn-success" type="submit" name="UbiAnt" value="PorUbicar">Por Ubicar</button>
            </form>
            <form action="leerInsRedist.jsp" method="post">
                <div class="row">
                    <h5 class="col-lg-12">CB del Insumo a Mover</h5>
                    <div class="col-lg-12">
                        <input class="hidden" name="UbiAnt" value="<%=UbiAnt%>" />
                        <input class="form-control" name="ClaPro" value="<%=ClaPro%>" autofocus="" />
                    </div>
                </div>
                <br/>
                <div class="row">
                    <div class="col-lg-12">
                        <button class="btn btn-block btn-primary btn-lg">Leer Insumo</button>
                    </div>
                </div>
            </form>
            <hr/>
            <h4>Insumos Médicos</h4>
            <%
                try {
                    if (!UbiAnt.equals("PorUbicar")) {

                        con.conectar();
                        ResultSet rset = con.consulta("select u.F_DesUbi, l.F_ClaPro, l.F_ExiLot, m.F_DesPro, l.F_ClaLot, DATE_FORMAT(l.F_FecCad, '%d/%m/%Y') as F_FecCad, l.F_IdLote from tb_lote l, tb_medica m, tb_ubica u where l.F_ClaPro = m.F_ClaPro AND l.F_Ubica = u.F_ClaUbi and l.F_ExiLot!=0 and u.F_Cb = '" + UbiAnt + "' and l.F_Cb = '" + ClaPro + "' ");
                        while (rset.next()) {
            %>
            <h5>
                Ubicación: <%=rset.getString("F_DesUbi")%>
                <br/>
                Clave: <%=rset.getString("F_ClaPro")%>
                <br/>
                Cantidad: <%=formatter.format(rset.getInt("F_ExiLot"))%>
                <br/>
                Descripción: <%=rset.getString("F_DesPro")%>
                <br/>
                Lote: <%=rset.getString("F_ClaLot")%>
                <br/>
                Caducidad: <%=rset.getString("F_FecCad")%>
                <br/>
            </h5>
            <form action="ingCantRedist.jsp" method="post">
                <input class="hidden" name="UbiAnt" value="<%=UbiAnt%>" />
                <input class="hidden" name="ClaPro" value="<%=ClaPro%>" />
                <input value="<%=rset.getString("F_IdLote")%>" class="hidden" name="idLote" />
                <button class="btn btn-block btn-success" type="submit">Seleccionar</button>
            </form>
            <hr/>
            <%
                }
            } else {

                con.conectar();
                ResultSet rset = con.consulta("select u.F_DesUbi, l.F_ClaPro, l.F_ExiLot, m.F_DesPro, l.F_ClaLot, DATE_FORMAT(l.F_FecCad, '%d/%m/%Y') as F_FecCad, l.F_IdLote from tb_lote l, tb_medica m, tb_ubica u where l.F_ClaPro = m.F_ClaPro AND l.F_Ubica = u.F_ClaUbi and l.F_ExiLot!=0 and u.F_Cb = '1'  ");
                while (rset.next()) {
            %>
            <h5>
                Ubicación: <%=rset.getString("F_DesUbi")%>
                <br/>
                Clave: <%=rset.getString("F_ClaPro")%>
                <br/>
                Cantidad: <%=formatter.format(rset.getInt("F_ExiLot"))%>
                <br/>
                Descripción: <%=rset.getString("F_DesPro")%>
                <br/>
                Lote: <%=rset.getString("F_ClaLot")%>
                <br/>
                Caducidad: <%=rset.getString("F_FecCad")%>
                <br/>
            </h5>
            <form action="ingCantRedist.jsp" method="post">
                <input class="hidden" name="UbiAnt" value="<%=UbiAnt%>" />
                <input class="hidden" name="ClaPro" value="<%=ClaPro%>" />
                <input value="<%=rset.getString("F_IdLote")%>" class="hidden" name="idLote" />
                <button class="btn btn-block btn-success" type="submit">Seleccionar</button>
            </form>
            <hr/>
            <%

                        }
                        con.cierraConexion();
                    }
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
</html>
