<%-- 
    Document   : capturaISEM.jsp
    Created on : 14-jul-2014, 14:48:02
    Author     : Americo
--%>

<%@page import="java.text.*"%>
<%@page import="conn.ConectionDB"%>
<%@page import="ISEM.CapturaPedidos"%>
<%@page import="javax.servlet.http.HttpSession"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    DecimalFormat formatter = new DecimalFormat("#,###,###");
    DecimalFormatSymbols custom = new DecimalFormatSymbols();
    custom.setDecimalSeparator(',');
    formatter.setDecimalFormatSymbols(custom);
    HttpSession sesion = request.getSession();
    String usua = "";
    if (sesion.getAttribute("Usuario") != null) {
        usua = (String) sesion.getAttribute("Usuario");
    } else {
        response.sendRedirect("indexIsem.jsp");
    }
    ConectionDB con = new ConectionDB();
    CapturaPedidos indice = new CapturaPedidos();
    String proveedor = "", fecEnt = "", horEnt = "", claPro = "", desPro = "", NoCompra = "";
    try {
        NoCompra = (String) sesion.getAttribute("NoCompra");
        proveedor = (String) sesion.getAttribute("proveedor");
        fecEnt = (String) sesion.getAttribute("fec_entrega");
        horEnt = (String) sesion.getAttribute("hor_entrega");
        claPro = (String) sesion.getAttribute("clave");
        desPro = (String) sesion.getAttribute("descripcion");
    } catch (Exception e) {

    }
    if (proveedor == null) {
        proveedor = "";
        fecEnt = "";
        horEnt = "";
    }
    if (claPro == null) {
        claPro = "";
        desPro = "";
    }

    if (NoCompra == null) {
        NoCompra = "";
    }

    System.out.println(NoCompra);
    if (NoCompra.equals("")) {
        NoCompra = indice.noCompra();
        sesion.setAttribute("NoCompra", NoCompra);
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
    <body onload="focusLocus();
            SelectProve(FormBusca);">
        <div class="container">
            <h3>ISEM - Captura de Entregas</h3>
            <a class="btn btn-default" href="capturaISEM.jsp">Captura de Órdenes de Compra</a>
            <a class="btn btn-default" href="verFoliosIsem.jsp">Ver Órdenes de Compra</a>
            <form name="FormBusca" action="CapturaPedidos" method="post">
                <div class="row">
                    <label class="col-sm-2 col-sm-offset-8 text-right">
                        <h4>Número de Compra</h4>
                    </label>
                    <div class="col-sm-2">
                        <input type="text" class="form-control" id="NoCompra" name="NoCompra" value="<%=NoCompra%>" readonly=""  />
                    </div>
                </div>
                <br/>
                <div class="row">
                    <label class="col-sm-1">
                        <h4>Proveedor</h4>
                    </label>
                    <div class="col-sm-7">
                        <select class="form-control" name="Proveedor" id="Proveedor" onchange="SelectProve(this.form);
                                document.getElementById('Fecha').focus()">
                            <option value="">--Proveedor--</option>
                            <%
                                try {
                                    con.conectar();
                                    ResultSet rset = con.consulta("select F_ClaProve, F_NomPro from tb_proveedor order by F_NomPro");
                                    while (rset.next()) {
                            %>
                            <option value="<%=rset.getString(1)%>"
                                    <%
                                        if (proveedor.equals(rset.getString(1))) {
                                            out.println("selected");
                                        }
                                    %>
                                    ><%=rset.getString(2)%></option>
                            <%
                                    }
                                    con.cierraConexion();
                                } catch (Exception e) {
                                }
                            %>

                        </select>
                    </div>
                </div>
                <div class="row">
                    <label class="col-sm-2">
                        <h4>Fecha de Entrega</h4>
                    </label>
                    <div class="col-sm-2">
                        <input type="text" class="form-control" data-date-format="dd/mm/yyyy" id="Fecha" name="Fecha" readonly value="<%=fecEnt%>" onchange="document.getElementById('Hora').focus()" />
                    </div>
                    <label class="col-sm-2">
                        <h4>Hora de Entrega</h4>
                    </label>
                    <div class="col-sm-2">
                        <select class="form-control" id="Hora" name="Hora" onchange="document.getElementById('Clave').focus()">
                            <%
                                for (int i = 0; i < 24; i++) {
                                    if (i != 24) {
                            %>
                            <option value="<%=i%>:00"
                                    <%
                                        if (horEnt.equals(i + ":00")) {
                                            out.println("selected");
                                        }
                                    %>
                                    ><%=i%>:00</option>
                            <option value="<%=i%>:30"
                                    <%
                                        if (horEnt.equals(i + ":30")) {
                                            out.println("selected");
                                        }
                                    %>
                                    ><%=i%>:30</option>
                            <%
                            } else {
                            %>
                            <option value="<%=i%>:00"
                                    <%
                                        if (horEnt.equals(i + ":00")) {
                                            out.println("selected");
                                        }
                                    %>
                                    ><%=i%>:00</option>
                            <%
                                    }
                                }
                            %>
                        </select>
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
                        <button class="btn btn-primary btn-block" onclick="return validaClaDes(this);" name="accion" value="Clave">Clave</button>
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
            </form>
            <br/>
            <form name="FormCaptura" action="CapturaPedidos" method="post">
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
                        <%
                            try {
                                con.conectar();
                                ResultSet rset = con.consulta("select pp.F_CantMax, pp.F_CantMin, m.F_PrePro from tb_prodprov pp, tb_medica m where m.F_ClaPro = pp.F_ClaPro and pp.F_ClaPro = '" + claPro + "' ");
                                while (rset.next()) {
                                    int cantUsada = 0;
                                    int cantMax = 0;
                                    cantMax = rset.getInt(1);
                                    ResultSet rset2 = con.consulta("select sum(F_Cant) from tb_pedidoisem where F_Clave='" + claPro + "' and F_StsPed !='2'");
                                    while (rset2.next()) {
                                        cantUsada = rset2.getInt(1);
                                    }
                                    int cantRestante = cantMax - cantUsada;
                        %>
                        <div class="row">
                            <label class="col-sm-2 text-right">
                                <h4>Cantidad Solicitada</h4>
                            </label>
                            <div class="col-sm-2">
                                <input type="text" class="form-control" readonly value="<%=formatter.format(cantUsada)%>" name="" id=""/>
                            </div>
                            <label class="col-sm-2">
                                <h4>Cantidad Máxima</h4>
                            </label>
                            <div class="col-sm-2">
                                <input type="text" class="form-control" readonly value="<%=formatter.format(cantMax)%>" name="" id=""/>
                            </div>
                            <label class="col-sm-2 text-right">
                                <h4>Cantidad Restante</h4>
                            </label>
                            <div class="col-sm-2">
                                <input type="text" class="form-control" readonly value="<%=formatter.format(cantRestante)%>" name="CantRest" id="CantRest"/>
                            </div>
                        </div>
                        <div class="row">
                            <label class="col-sm-1">
                                <h4>Pres.</h4>
                            </label>
                            <div class="col-sm-3">
                                <input type="text" class="form-control" readonly value="<%=rset.getString(3)%>" name="" id=""/>
                            </div>
                        </div>
                        <br/>
                        <%
                                }
                                con.cierraConexion();
                            } catch (Exception e) {

                            }
                        %>


                        <div class="row">
                            <%
                                String cantidad = "0";
                                try {
                                    con.conectar();
                                    ResultSet rset = con.consulta(" select SUM(F_ExiLot) from tb_lote where F_ClaPro = '" + claPro + "' group by F_ClaPro  ");
                                    while (rset.next()) {
                                        cantidad = rset.getString(1);
                                        System.out.println(cantidad);
                                    }
                                    if (cantidad == null) {
                                        cantidad = "0";
                                    }
                                    con.cierraConexion();
                                } catch (Exception e) {
                                    System.out.println(e.getMessage());
                                }
                            %>
                            <label class="col-sm-2 text-center">
                                <h4>Cant. en Almacen</h4>
                            </label>
                            <div class="col-sm-2">
                                <input type="text" class="form-control" name="CantAlm" id="CantAlm" readonly="" value="<%=cantidad%>" />
                            </div>
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
                                <input type="text" class="form-control" name="CanPro" id="CanPro" onKeyPress="return justNumbers(event);" />
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
            <table class="table table-bordered table-condensed table-striped">
                <tr>
                    <td><strong>Clave</strong></td>
                    <td><strong>Descripción</strong></td>
                    <!--td><strong>Lote</strong></td>
                    <td><strong>Caducidad</strong></td-->
                    <td><strong>Cantidad</strong></td>
                    <td></td>
                </tr>
                <%
                    try {
                        con.conectar();
                        ResultSet rset = con.consulta("select s.F_Clave, m.F_DesPro, s.F_Lote, DATE_FORMAT(F_Cadu, '%d/%m/%Y'), s.F_Cant, F_IdIsem from tb_pedidoisem s, tb_medica m where s.F_Clave = m.F_ClaPro and F_IdUsu = '" + (String) sesion.getAttribute("Usuario") + "' and F_NoCompra = '" + NoCompra + "' and F_StsPed = '0' ");
                        while (rset.next()) {
                %>
                <tr>
                    <td><%=rset.getString(1)%></td>
                    <td><%=rset.getString(2)%></td>
                    <!--td><%=rset.getString(3)%></td>
                    <td><%=rset.getString(4)%></td-->
                    <td><%=formatter.format(rset.getInt(5))%></td>
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
            <div class="row">
                <form name="FormCaptura" action="CapturaPedidos" method="post">
                    <div class="col-sm-6">
                        <button class="btn btn-success btn-block" name="accion" value="confirmar" onclick="return confirm('¿Seguro que desea CONFIRMAR el pedido?')">Confirmar Orden de Compra</button>
                    </div>
                    <div class="col-sm-6">
                        <button class="btn btn-danger btn-block" name="accion" value="cancelar" onclick="return confirm('¿Seguro que desea CANCELAR el pedido?')">Cancelar Orden de Compra</button>
                    </div>
                </form>
            </div>
        </div>
    </body>
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="js/jquery-1.9.1.js"></script>
    <script src="js/bootstrap.js"></script>
    <script src="js/jquery-ui-1.10.3.custom.js"></script>
    <script src="js/bootstrap-datepicker.js"></script>
    <script>

                            function justNumbers(e)
                            {
                                var keynum = window.event ? window.event.keyCode : e.which;
                                if ((keynum === 8) || (keynum === 46))
                                    return true;

                                return /\d/.test(String.fromCharCode(keynum));
                            }
                            function focusLocus() {
                                document.getElementById('Proveedor').focus();
                                if (document.getElementById('Fecha').value !== "") {
                                    document.getElementById('Clave').focus();
                                }
                                if (document.getElementById('ClaPro').value !== "") {
                                    document.getElementById('Prioridad').focus();
                                }
                            }

                            $(function() {
                                $("#Fecha").datepicker();
                                $("#Fecha").datepicker('option', {dateFormat: 'dd/mm/yy'});
                            });
                            $(function() {
                                $("#CadPro").datepicker();
                                $("#CadPro").datepicker('option', {dateFormat: 'dd/mm/yy'});
                            });


                            $(function() {
                                var availableTags = [
        <%
            try {
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
                                var CanRes = document.getElementById('CantRest').value;
                                CanRes=CanRes.replace(",","");
                                CanRes=CanRes.replace(",","");
                                CanRes=CanRes.replace(",","");
                                CanRes=CanRes.replace(",","");
                                CanRes=CanRes.replace(",","");
                                if (parseInt(CanRes) < parseInt(CanPro)) {
                                    alert("La Cantidad Solicitada no puede ser mayor a la Cantidad Restante");
                                    return false;
                                }
                                if (ClaPro === "" || DesPro === "" || CanPro === "") {
                                    alert("Complete los datos");
                                    return false;
                                }
                                return true;
                            }


                            function SelectProve(form) {
        <%
            try {
                con.conectar();
                ResultSet rset3 = con.consulta("select DISTINCT F_ClaProve from tb_prodprov order by F_ClaProve");
                while (rset3.next()) {
                    out.println("if (form.Proveedor.value == '" + rset3.getString(1) + "') {");
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

    </script>
</html>
