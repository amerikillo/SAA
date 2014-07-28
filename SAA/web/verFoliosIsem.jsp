<%-- 
    Document   : capturaISEM.jsp
    Created on : 14-jul-2014, 14:48:02
    Author     : Americo
--%>

<%@page import="conn.ConectionDB"%>
<%@page import="ISEM.CapturaPedidos"%>
<%@page import="javax.servlet.http.HttpSession"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%java.text.DateFormat df1 = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("dd/MM/yyyy"); %>
<%
    HttpSession sesion = request.getSession();
    String usua = "";
    if (sesion.getAttribute("Usuario") != null) {
        usua = (String) sesion.getAttribute("Usuario");
    } else {
        response.sendRedirect("indexIsem.jsp");
    }
    ConectionDB con = new ConectionDB();
    String proveedor = "", Fecha = "", horEnt = "", claPro = "", desPro = "", NoCompra = "";
    try {
        NoCompra = (String) sesion.getAttribute("NoCompra");
        proveedor = (String) sesion.getAttribute("proveedor");
        Fecha = (String) sesion.getAttribute("fec_entrega");
        horEnt = (String) sesion.getAttribute("hor_entrega");
        claPro = (String) sesion.getAttribute("clave");
        desPro = (String) sesion.getAttribute("descripcion");
    } catch (Exception e) {

    }
    try {
        Fecha = request.getParameter("Fecha");
    } catch (Exception e) {
        System.out.println(e.getMessage());
    }
    if (Fecha == null) {
        Fecha = "";
    }
    try {
        NoCompra = request.getParameter("NoCompra");
    } catch (Exception e) {
        System.out.println(e.getMessage());
    }
    if (Fecha == null) {
        NoCompra = "";
    }

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>ISEM</title>
        <!-- Estilos CSS -->
        <link href="css/bootstrap.css" rel="stylesheet">
        <link href="css/datepicker3.css" rel="stylesheet">
        <link rel="stylesheet" href="css/cupertino/jquery-ui-1.10.3.custom.css" />
        <link href="css/navbar-fixed-top.css" rel="stylesheet">
        <!---->
    </head>
    <body onload="SelectProve(FormBusca);">
        <div class="container">
            <div class="row">
                <h3>ISEM - Ver Folios</h3>
                <a class="btn btn-default" href="capturaISEM.jsp">Captura de Órdenes de Compra</a>
                <a class="btn btn-default" href="verFoliosIsem.jsp">Ver Folios Anteriores</a>
            </div>
            <br/>
            <div class="row">
                <form method="post" action="verFoliosIsem.jsp">
                    <label class="col-sm-2">
                        <h4>Fecha de Entrega:</h4>
                    </label>
                    <div class="col-sm-2">
                        <input type="text" class="form-control" data-date-format="dd/mm/yyyy" id="Fecha" name="Fecha" readonly value="<%=Fecha%>" onchange="document.getElementById('Hora').focus()" />
                    </div>
                    <div class="col-sm-1">
                        <button class="btn btn-primary" name="accion" value="fecha">Fecha</button>
                    </div>
                </form>
                <form method="post" action="CapturaPedidos?accion=verFolio">
                    <label class="col-sm-1">
                        <h4>Folios:</h4>
                    </label>
                    <div class="col-sm-5">
                        <select class="form-control" name="NoCompra" onchange="this.form.submit();">
                            <option value="">-- Proveedor -- Folios --</option>
                            <%
                                try {
                                    con.conectar();
                                    ResultSet rset = con.consulta("select o.F_NoCompra, p.F_NomPro from tb_pedidoisem o, tb_proveedor p where o.F_Provee = p.F_ClaProve and F_FecSur = '" + df1.format(df2.parse(Fecha)) + "'  group by o.F_NoCompra");
                                    while (rset.next()) {
                            %>
                            <option value="<%=rset.getString(1)%>"><%=rset.getString(2)%> - <%=rset.getString(1)%></option>
                            <%
                                    }
                                    con.cierraConexion();
                                } catch (Exception e) {
                                    System.out.println(e.getMessage());
                                }
                            %>
                        </select>
                    </div>
                </form>
            </div>
            <%

            %>
            <form name="FormBusca" action="verFoliosIsem.jsp" method="post">
                <div class="row">
                    <h4 class="col-sm-1">Folio: </h4>
                    <div class="col-sm-2">
                        <input class="form-control" value="<%=NoCompra%>" name="NoCompra" readonly="" />
                    </div>
                </div>
                <div class="row">
                    <h4 class="col-sm-1">Proveedor: </h4>
                    <div class="col-sm-10">
                        <input class="form-control" value="" name="Proveedor1" id="Proveedor1" readonly="" />
                        <input class="form-control" value="" name="Cla_Prove" id="Cla_Prove" readonly="" />
                    </div>
                </div>
                <div class="row">
                    <h4 class="col-sm-2">Fecha de Entrega: </h4>
                    <div class="col-sm-2">
                        <input class="form-control" value="" readonly="" id="Fecha1" name="Fecha1" />
                    </div>
                    <h4 class="col-sm-2">Hora de Entrega: </h4>
                    <div class="col-sm-2">
                        <input class="form-control" value="" id="Hora" name="Hora" readonly="" />
                    </div>
                </div>
                <br/>

                <div class="row">

                    <label class="col-sm-1 text-right">
                        <h4>Clave</h4>
                    </label>
                    <div class="col-sm-2">
                        <!--input type="text" class="form-control" id="Clave" name="Clave" /-->
                        <select name="Clave" id="Clave" class="form-control">
                            <option>-- Seleccione Clave --</option>
                        </select>
                    </div>
                    <div class="col-sm-1">
                        <button class="btn btn-primary btn-block" onclick="return validaClaDes(this);" name="accion" value="ClaveVer">Clave</button>
                    </div>
                    <!--label class="col-sm-1 text-right">
                        <h4>Descripción</h4>
                    </label>
                    <div class="col-sm-5">
                        <input type="text" class="form-control" id="Descripcion" name="Descripcion" />
                    </div>
                    <div class="col-sm-1">
                        <button class="btn btn-primary"  onclick="return validaClaDes(this);" name="accion" value="Descripcion">Descripción</button>
                    </div-->
                </div>
                <br/>
                <div class="panel panel-default">
                    <div class="panel-body">
                        <div class="row">
                            <label class="col-sm-1 text-right">
                                <h4>Clave</h4>
                            </label>
                            <div class="col-sm-2">
                                <input type="text" class="form-control" readonly value="<%=claPro%>" name="ClaPro" id="ClaPro"/>
                            </div>
                            <label class="col-sm-1">
                                <h4>Descripción</h4>
                            </label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" readonly value="<%=desPro%>" name="DesPro" id="DesPro"/>
                            </div>
                        </div>
                        <br/>
                        <div class="row">
                            <label class="col-sm-1 text-center">
                                <h4>Prioridad</h4>
                            </label>
                            <div class="col-sm-2">
                                <select  class="form-control" name="Prioridad" id="Prioridad" onchange="document.getElementById('CanPro').focus()" >
                                    <option>1</option>
                                    <option>2</option>
                                    <option>3</option>
                                    <option selected="">4</option>
                                    <option>ND</option>
                                </select>
                            </div>
                            <label class="hidden">
                                <h4>Lote</h4>
                            </label>
                            <div class="hidden">
                                <input type="text" class="form-control" name="LotPro" id="LotPro" />
                            </div>
                            <label class="hidden">
                                <h4>Caducidad</h4>
                            </label>
                            <div class="hidden">
                                <input type="text" class="form-control" data-date-format="dd/mm/yyyy" readonly="" name="CadPro" id="CadPro"/>
                            </div><label class="col-sm-1 text-right">
                                <h4>Cantidad</h4>
                            </label>
                            <div class="col-sm-2">
                                <input type="text" class="form-control" name="CanPro" id="CanPro" />
                            </div>
                        </div>
                        <br/>
                        <div class="row">
                            <label class="col-sm-2 text-right">
                                <h4>Observaciones</h4>
                            </label>
                            <div class="col-sm-10">
                                <textarea id="Observaciones" name="Observaciones" class="form-control" rows="7"></textarea>
                            </div>
                        </div>
                        <br/>
                        <button class="btn btn-block btn-primary" name="accion" value="capturar" onclick="return validaCaptura();">Capturar</button>

                    </div>

                </div>
            </form>
            <br/>
            <%

            %>

            <div class="row">
                <br/>
                <table class="table table-bordered table-condensed table-striped">
                    <tr>
                        <td><strong>Clave</strong></td>
                        <td><strong>Descripción</strong></td>
                        <!--td><strong>Lote</strong></td>
                        <td><strong>Caducidad</strong></td-->
                        <td><strong>Cantidad</strong></td>
                        <td></td>
                    </tr>
                    <%                        try {
                            con.conectar();
                            ResultSet rset = con.consulta("select s.F_Clave, m.F_DesPro, s.F_Lote, DATE_FORMAT(F_Cadu, '%d/%m/%Y'), s.F_Cant, F_IdIsem from tb_pedidoisem s, tb_medica m where s.F_Clave = m.F_ClaPro and F_IdUsu = '" + (String) sesion.getAttribute("Usuario") + "' and F_NoCompra = '" + NoCompra + "' ");
                            while (rset.next()) {
                    %>
                    <tr>
                        <td><%=rset.getString(1)%></td>
                        <td><%=rset.getString(2)%></td>
                        <!--td><%=rset.getString(3)%></td>
                        <td><%=rset.getString(4)%></td-->
                        <td><%=rset.getString(5)%></td>
                        <td>
                            <form action="CapturaPedidos" method="post">
                                <input name="id" value="<%=rset.getString(6)%>" class="hidden" />
                                <button class="btn btn-danger" name="accion" value="eliminaClave"><span class="glyphicon glyphicon-remove"></span></button>
                            </form>
                        </td>
                    </tr>
                    <%
                            }
                            con.cierraConexion();
                        } catch (Exception e) {

                        }
                    %>

                </table>
            </div>
        </div>
    </body>
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="js/jquery-1.9.1.js"></script>
    <script src="js/bootstrap.js"></script>
    <script src="js/jquery-ui-1.10.3.custom.js"></script>
    <script src="js/bootstrap-datepicker.js"></script>
    <script>
                            function SelectProve(form) {

        <%
            try {
                con.conectar();
                ResultSet rset3 = con.consulta("select DISTINCT F_ClaProve from tb_prodprov order by F_ClaProve");
                while (rset3.next()) {
                    out.println("if (form.Cla_Prove.value == '" + rset3.getString(1) + "') {");
                    out.println("var select = document.getElementById('Clave');");
                    out.println("select.options.length = 0;");
                    int i = 1;
                    ResultSet rset4 = con.consulta("select F_ClaPro from tb_prodprov where F_ClaProve = '" + rset3.getString(1) + "'");
                    while (rset4.next()) {
                        out.println("select.options[select.options.length] = new Option('" + rset4.getString(1) + "', '" + rset4.getString(1) + "');"
                        );
                        i++;
                    }
                    out.println("}");
                }
                con.cierraConexion();
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        %>
                            }

                            $(function() {
                                $("#Fecha").datepicker();
                                $("#Fecha").datepicker('option', {dateFormat: 'dd/mm/yy'});
                            });
                            $(function() {
                                $("#Fecha1").datepicker();
                                $("#Fecha1").datepicker('option', {dateFormat: 'dd/mm/yy'});
                            });


                            $(function() {
                                var availableTags = [
        <%            try {
                con.conectar();
                ResultSet rset = con.consulta("SELECT F_DesPro  FROM tb_medica");
                while (rset.next()) {
                    out.println("\'" + rset.getString("F_DesPro") + "\',");
                }
                con.cierraConexion();
            } catch (Exception e) {
            }
        %>
                                ];
                                $("#Descripcion").autocomplete({
                                    source: availableTags
                                });
                            });

                            function validaClaDes(boton) {
                                var btn = boton.value;
                                var prove = document.getElementById('Proveedor').value;
                                var fecha = document.getElementById('Fecha').value;
                                var hora = document.getElementById('Hora').value;
                                var NoCompra = document.getElementById('NoCompra').value;
                                if (prove === "" || fecha === "" || hora === "0:00" || NoCompra === "") {
                                    alert("Complete los datos");
                                    return false;
                                }
                                var valor = "";
                                var mensaje = "";
                                if (btn === "Clave") {
                                    valor = document.getElementById('Clave').value;
                                    mensaje = "Introduzca la clave";
                                }
                                if (btn === "Descripcion") {
                                    valor = document.getElementById('Descripcion').value;
                                    mensaje = "Introduzca la descripcion";
                                }
                                if (valor === "") {
                                    alert(mensaje);
                                    return false;
                                }
                                return true;
                            }

                            function validaCaptura() {
                                var ClaPro = document.getElementById('ClaPro').value;
                                var DesPro = document.getElementById('DesPro').value;
                                var CanPro = document.getElementById('CanPro').value;
                                if (ClaPro === "" || DesPro === "" || CanPro === "") {
                                    alert("Complete los datos");
                                    return false;
                                }
                                return true;
                            }

    </script>
</html>
