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
    /**
     * JSP para ingresar la cantidad y la ubicación de la redistribución
     */
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
    /**
     * Se obtiene la ubicación del F_IdLote del parametro a redistribuir
     */
    try {
        con.conectar();
        ResultSet rset = con.consulta("select F_Ubica from tb_lote where F_IdLote='" + idLote + "'");
        while (rset.next()) {
            UbiAnt = rset.getString(1);
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

        <!---->
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SIALSS</title>
    </head>
    <body>
        <div class="container">
            <h1>SIALSS</h1>

            <%@include file="../jspf/menuPrincipal.jspf"%>
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
                    /**
                     * Para mostrar información del insumo
                     */
                    ResultSet rset = con.consulta("select u.F_DesUbi, l.F_ClaPro, l.F_ExiLot, m.F_DesPro, l.F_ClaLot, DATE_FORMAT(l.F_FecCad, '%d/%m/%Y') as F_FecCad, l.F_IdLote, u.F_ClaUbi, u.F_Cb as CbUbica from tb_lote l, tb_medica m, tb_ubica u where l.F_ClaPro = m.F_ClaPro AND l.F_Ubica = u.F_ClaUbi and l.F_ExiLot!=0 and l.F_IdLote = '" + idLote + "' ");
                    while (rset.next()) {
                        int banAlerta = 0;
                        /**
                         * Para calcular la cantidad apartada para este insumo
                         */
                        ResultSet rset2 = con.consulta("select F_IdLot, SUM(F_Cant), F_idFact from tb_facttemp where F_IdLot = '" + idLote + "' and F_StsFact <5 group by F_IdLot");
                        while (rset2.next()) {
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
                <!--DIV que se recarga-->
                <div id="divApartados1">
                    <div class="row">
                        <h5 class="col-lg-12">Cantidad a Mover:</h5>
                        <!--
                        Se pone la cantidad máxima a mover de la resta entre la existencia en lote menos lo apartado
                        -->
                        <div class="col-lg-12">
                            <input class="form-control" placeholder="Cantidad a Mover" type="number" name="CantMov" id="CantMov" min="1" max="<%=(rset.getInt("F_ExiLot") - canApartada)%>" />
                        </div>
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
                <!--DIV que se recarga-->
                <div id="divApartados">
                    <br/>
                    <%
                        /**
                         * Nos muestra los registros en donde está apartada la
                         * clave y se agrega un boton para poder eliminar esos
                         * registros
                         */
                        rset2 = con.consulta("select F_IdLot, SUM(F_Cant), F_idFact, F_Id from tb_facttemp where F_IdLot = '" + idLote + "' and F_StsFact <5 group by F_IdFact");
                        while (rset2.next()) {
                            canApartada = rset2.getInt(2);
                    %>
                    <div class="alert alert-danger">
                        <div class="row">
                            <strong class="col-sm-11">Este insumo está apartado con <%=canApartada%> piezas en el concentrado <%=rset2.getInt("F_IdFact")%></strong>
                            <div class="col-sm-1">
                                <button class="btn btn-sm btn-danger" onclick="eliminarFactTemp(this)" value="<%=rset2.getInt("F_Id")%>" type="button"><span class="glyphicon glyphicon-remove"></span></button>
                            </div>
                        </div>
                    </div>
                    <%
                        }
                        
                        /**
                         * Nos dice cuál es la cantidad máxima a mover
                         */
                        rset2 = con.consulta("select F_IdLot, SUM(F_Cant), F_idFact from tb_facttemp where F_IdLot = '" + idLote + "' and F_StsFact <5 group by F_IdLot");
                        while (rset2.next()) {
                            canApartada = rset2.getInt(2);
                    %>
                    <div class="alert alert-warning">
                        <strong>Cantidad máxima a mover: <%=(rset.getInt("F_ExiLot") - canApartada)%> piezas</strong>
                    </div>
                    <%
                        }
                    %>

                </div>
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

        <!-- 
    ================================================== -->
        <!-- Se coloca al final del documento para que cargue mas rapido -->
        <!-- Se debe de seguir ese orden al momento de llamar los JS -->

        <script src="../js/jquery-1.9.1.js"></script>
        <script src="../js/bootstrap.js"></script>
        <script src="../js/jquery-ui-1.10.3.custom.js"></script>
        <script src="../js/bootstrap-datepicker.js"></script>
        <script src="../js/funcRedistribucion.js"></script>
        <script>
        </script>
    </body>
</html>
