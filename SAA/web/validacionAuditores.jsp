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
     * Para validar por auditoria las remisiones
     */
    HttpSession sesion = request.getSession();
    String usua = "", tipo = "";
    if (sesion.getAttribute("nombre") != null) {
        usua = (String) sesion.getAttribute("nombre");
        tipo = (String) sesion.getAttribute("Tipo");
    } else {
        response.sendRedirect("index.jsp");
    }
    ConectionDB con = new ConectionDB();
    String F_Cb = "", F_Clave = "", Clave = "";

    try {
        F_Cb = request.getParameter("F_Cb");
        Clave = request.getParameter("Nombre");
    } catch (Exception e) {

    }

    try {
        F_Clave = request.getParameter("F_Clave");
    } catch (Exception e) {

    }

    if (F_Clave == null) {
        F_Clave = "";
    }
    if (F_Cb == null) {
        F_Cb = "";
    }
    if (Clave == null) {
        Clave = (String) sesion.getAttribute("Nombre");
        if (Clave == null) {
            Clave = "";
        }
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
        <!---->
        <title>SIALSS</title>
    </head>
    <body>
        <div class="container">
            <h1>SIALSS</h1>
            <h4>Módulo - Sistema de Administración de Almacenes (SAA)</h4>

            <%@include file="jspf/menuPrincipal.jspf"%>

            <h3>
                Validación Auditores
            </h3>
            <div class="panel panel-primary">
                <div class="panel-body">
                    <form method="post" action="validacionAuditores.jsp">
                        <div class="row">
                        </div>

                        <div class="row">
                            <h4 class="col-sm-3">Seleccione el proveedor</h4>
                            <div class="col-sm-5">
                                <select id="Nombre" name="Nombre" class="form-control">
                                    <option value="">Unidad</option>

                                    <%
                                        /**
                                         * Seleccion del concentrado con el cual
                                         * trabajar
                                         */
                                        try {
                                            con.conectar();
                                            ResultSet rset = con.consulta("select u.F_ClaCli, u.F_NomCli, f.F_IdFact from tb_uniatn u, tb_facttemp f where u.F_StsCli = 'A' and f.F_ClaCli = u.F_ClaCli and f.F_StsFact<>'5'group by f.F_IdFact order by f.F_IdFact desc;");
                                            while (rset.next()) {
                                    %>
                                    <option value="<%=rset.getString(3)%>"
                                            <%
                                                if (Clave.equals(rset.getString(3))) {
                                                    out.println("selected");
                                                }
                                            %>
                                            ><%=rset.getString(3) + "-" + rset.getString(2)%></option>
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
                            <h4 class="col-sm-2">Ingrese CB</h4>
                            <div class="col-sm-3">
                                <input class="form-control" name="F_Cb" autofocus />
                            </div>
                            <h4 class="col-sm-2">Clave</h4>
                            <div class="col-sm-3">
                                <input class="form-control" name="F_Clave" />
                            </div>
                            <div class="col-sm-2">
                                <button class="btn btn-block btn-primary">Buscar</button>
                            </div>
                        </div>
                    </form>
                    <%
                        try {
                            /**
                             * Busqueda por clave o por CB
                             */
                            con.conectar();
                            ResultSet rset = null;
                            if (F_Cb != "") {
                                rset = con.consulta("SELECT	u.F_NomCli,	DATE_FORMAT(f.F_FecEnt, '%d/%m/%Y') as Fecha,	l.F_ClaPro,	l.F_ClaLot,	DATE_FORMAT(l.F_FecCad, '%d/%m/%Y') as fecha,	(f.F_Cant+0) as F_Cant,	l.F_Ubica,	f.F_IdFact,	l.F_Cb,	p.F_Pzs,	(f.F_Cant DIV p.F_Pzs) as cajas,	(f.F_Cant MOD p.F_Pzs) as resto FROM	tb_facttemp f,	tb_lote l,	tb_uniatn u,	tb_pzxcaja p WHERE	f.F_IdLot = l.F_IdLote AND f.F_ClaCli = u.F_ClaCli AND p.F_ClaPro = l.F_ClaPro AND F_Cb='" + F_Cb + "' and f.F_IdFact = '" + Clave + "' group by f.F_ClaCli;");
                            }

                            if (F_Clave != "") {
                                rset = con.consulta("SELECT	u.F_NomCli,	DATE_FORMAT(f.F_FecEnt, '%d/%m/%Y') as Fecha,	l.F_ClaPro,	l.F_ClaLot,	DATE_FORMAT(l.F_FecCad, '%d/%m/%Y') as fecha,	(f.F_Cant+0) as F_Cant,	l.F_Ubica,	f.F_IdFact,	l.F_Cb,	p.F_Pzs,	(f.F_Cant DIV p.F_Pzs) as cajas,	(f.F_Cant MOD p.F_Pzs) as resto FROM	tb_facttemp f,	tb_lote l,	tb_uniatn u,	tb_pzxcaja p WHERE	f.F_IdLot = l.F_IdLote AND f.F_ClaCli = u.F_ClaCli AND p.F_ClaPro = l.F_ClaPro AND l.F_ClaPro='" + F_Clave + "' and f.F_IdFact = '" + Clave + "' group by f.F_ClaCli;");
                            }

                            while (rset.next()) {
                    %>
                    <div class="row">
                        <h5 class="col-sm-8">Proveedor: <%=rset.getString("F_NomCli")%></h5>
                        <h5 class="col-sm-2">Fecha de Surtido: <%=rset.getString("Fecha")%> </h5>
                    </div>
                    <%
                            }
                            con.cierraConexion();
                        } catch (Exception e) {

                            System.out.println(e.getMessage());
                        }
                    %>
                </div>
                <div class="panel-footer">
                    <form action="Facturacion" method="post">
                        <input class="hidden" name="Nombre" value="<%=Clave%>" />
                        <div class="table-responsive">
                            <table class="table table-bordered table-condensed table-striped">
                                <tr>
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
                                <%
                                    /**
                                     * Para validar el insumo y pueda ser
                                     * remisionado
                                     */
                                    int banBtnVal = 0;
                                    try {
                                        con.conectar();
                                        ResultSet rset = null;
                                        if (F_Cb != "") {
                                            rset = con.consulta("SELECT	u.F_NomCli,	DATE_FORMAT(f.F_FecEnt, '%d/%m/%Y') as Fecha,	l.F_ClaPro,	l.F_ClaLot,	DATE_FORMAT(l.F_FecCad, '%d/%m/%Y') as cadu,	(f.F_Cant+0) as F_Cant,	l.F_Ubica,	f.F_IdFact,	l.F_Cb,	p.F_Pzs,	(f.F_Cant DIV p.F_Pzs) as cajas,	(f.F_Cant MOD p.F_Pzs) as resto, f.F_Id,m.F_DesPro  FROM	tb_facttemp f,	tb_lote l,	tb_uniatn u,	tb_pzxcaja p, tb_medica m WHERE m.F_ClaPro = l.F_ClaPro and 	f.F_IdLot = l.F_IdLote AND f.F_ClaCli = u.F_ClaCli AND p.F_ClaPro = l.F_ClaPro AND F_Cb='" + F_Cb + "' and f.F_IdFact = '" + Clave + "' and f.F_StsFact=1 group by f.F_Id;");
                                        }

                                        if (F_Clave != "") {
                                            rset = con.consulta("SELECT	u.F_NomCli,	DATE_FORMAT(f.F_FecEnt, '%d/%m/%Y') as Fecha,	l.F_ClaPro,	l.F_ClaLot,	DATE_FORMAT(l.F_FecCad, '%d/%m/%Y') as cadu,	(f.F_Cant+0) as F_Cant,	l.F_Ubica,	f.F_IdFact,	l.F_Cb,	p.F_Pzs,	(f.F_Cant DIV p.F_Pzs) as cajas,	(f.F_Cant MOD p.F_Pzs) as resto, f.F_Id,m.F_DesPro  FROM	tb_facttemp f,	tb_lote l,	tb_uniatn u,	tb_pzxcaja p, tb_medica m WHERE m.F_ClaPro = l.F_ClaPro and f.F_IdLot = l.F_IdLote AND f.F_ClaCli = u.F_ClaCli AND p.F_ClaPro = l.F_ClaPro AND l.F_ClaPro='" + F_Clave + "' and f.F_IdFact = '" + Clave + "' and f.F_StsFact=1 group by f.F_Id;");
                                        }
                                        while (rset.next()) {
                                            banBtnVal = 1;
                                %>
                                <tr>
                                    <td><%=rset.getString("F_Cb")%></td>
                                    <td><%=rset.getString("F_ClaPro")%></td>
                                    <td><%=rset.getString("F_ClaLot")%></td>
                                    <td><%=rset.getString("cadu")%></td>
                                    <td><%=rset.getString("F_Ubica")%></td>
                                    <td><%=rset.getString("cajas")%></td>
                                    <td><%=rset.getString("resto")%></td>
                                    <td><%=rset.getString("F_Cant")%></td>
                                    <td>
                                        <div class="row">
                                            <div class="col-sm-4">
                                                <a href="#" class="btn btn-warning btn-block" data-toggle="modal" data-target="#Rechazar<%=rset.getString("F_Id")%>"><span class="glyphicon glyphicon-barcode"></span></a>
                                            </div>
                                            <div class="col-sm-4">
                                                <a class="btn btn-block btn-success" onclick="return confirm('Desea Validar Esta Clave?')" href="Facturacion?accion=validaAuditor&folio=<%=rset.getString("F_Id")%>&Nombre=<%=Clave%>"><span class="glyphicon glyphicon-ok"></span></a>
                                            </div>
                                            <div class="col-sm-4 checkbox">
                                                <input type="checkbox" name="chkId" value="<%=rset.getString("F_Id")%>">
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="10">
                                        <%=rset.getString("F_DesPro")%>
                                    </td>
                                </tr>
                                <%
                                        }
                                        con.cierraConexion();
                                    } catch (Exception e) {
                                        System.out.println(e.getMessage());
                                    }
                                %>
                            </table>
                        </div>
                        <%
                            if (banBtnVal == 1) {
                        %>
                        <div class="row"><div class="col-sm-2 col-sm-offset-10">
                                <button class="btn btn-success" name="accion" value="validarVariasAuditor">Validar Varias</button>
                            </div>
                        </div>
                        <%
                            }
                        %>
                    </form>
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
        <%
            /**
             * Para rechazar, NO SE USA
             */
            try {
                con.conectar();
                ResultSet rset = null;
                if (F_Cb != "") {
                    rset = con.consulta("SELECT	u.F_NomCli,	DATE_FORMAT(f.F_FecEnt, '%d/%m/%Y') as Fecha,	l.F_ClaPro,	l.F_ClaLot,	DATE_FORMAT(l.F_FecCad, '%d/%m/%Y') as fecha,	(f.F_Cant+0) as F_Cant,	l.F_Ubica,	f.F_IdFact,	l.F_Cb,	p.F_Pzs,	(f.F_Cant DIV p.F_Pzs) as cajas,	(f.F_Cant MOD p.F_Pzs) as resto, f.F_Id, l.F_FolLot FROM	tb_facttemp f,	tb_lote l,	tb_uniatn u,	tb_pzxcaja p WHERE	f.F_IdLot = l.F_IdLote AND f.F_ClaCli = u.F_ClaCli AND p.F_ClaPro = l.F_ClaPro AND F_Cb='" + F_Cb + "' and f.F_IdFact = '" + Clave + "' group by f.F_IdFact;");
                }

                if (F_Clave != "") {
                    rset = con.consulta("SELECT	u.F_NomCli,	DATE_FORMAT(f.F_FecEnt, '%d/%m/%Y') as Fecha,	l.F_ClaPro,	l.F_ClaLot,	DATE_FORMAT(l.F_FecCad, '%d/%m/%Y') as fecha,	(f.F_Cant+0) as F_Cant,	l.F_Ubica,	f.F_IdFact,	l.F_Cb,	p.F_Pzs,	(f.F_Cant DIV p.F_Pzs) as cajas,	(f.F_Cant MOD p.F_Pzs) as resto, f.F_Id, l.F_FolLot FROM	tb_facttemp f,	tb_lote l,	tb_uniatn u,	tb_pzxcaja p WHERE	f.F_IdLot = l.F_IdLote AND f.F_ClaCli = u.F_ClaCli AND p.F_ClaPro = l.F_ClaPro AND l.F_ClaPro='" + F_Clave + "' and f.F_IdFact = '" + Clave + "' group by f.F_IdFact;");
                }
                while (rset.next()) {
        %>
        <div class="modal fade" id="Rechazar<%=rset.getString("F_Id")%>" tabindex="-1" role="dialog" aria-labelledby="basicModal" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <form action="Facturacion" method="get">
                        <div class="modal-header">
                            <div class="row">
                                <div class="col-sm-5">
                                    <h4 class="modal-title" id="myModalLabel">Edición CB</h4>
                                </div>
                            </div>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <h4 class="col-sm-1">CB</h4>
                                <div class="col-sm-3">
                                    <input value="<%=rset.getString("F_Cb")%>" class="form-control" name="F_Cb" />
                                    <input value="<%=rset.getString("F_FolLot")%>" class="hidden" name="F_FolLot" />
                                </div>
                            </div>
                            <div class="row">
                                <h4 class="col-sm-1">Clave</h4>
                                <div class="col-sm-2">
                                    <input value="<%=rset.getString("F_ClaPro")%>" class="form-control" readonly />
                                </div>
                                <h4 class="col-sm-1">Lote</h4>
                                <div class="col-sm-2">
                                    <input value="<%=rset.getString("F_ClaLot")%>" class="form-control" readonly />
                                </div>
                                <h4 class="col-sm-1">Cad</h4>
                                <div class="col-sm-2">
                                    <input value="<%=rset.getString("fecha")%>" class="form-control" readonly />
                                </div>
                                <h4 class="col-sm-1">Ubi</h4>
                                <div class="col-sm-2">
                                    <input value="<%=rset.getString("F_Ubica")%>" class="form-control" readonly />
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-primary" onclick="return confirm('Desea Actualizar el CB?');
                                    " name="accion" value="actualizarCBAuditor">Actualizar</button>
                            <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <%
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
    </body>

</html>

