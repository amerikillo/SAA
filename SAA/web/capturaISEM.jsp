<%-- 
    Document   : capturaISEM.jsp
    Created on : 14-jul-2014, 14:48:02
    Author     : Americo
--%>

<%@page import="java.util.Date"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
<%@page import="conn.ConectionDB_Linux"%>
<%@page import="java.text.*"%>
<%@page import="conn.ConectionDB"%>
<%@page import="ISEM.CapturaPedidos"%>
<%@page import="javax.servlet.http.HttpSession"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%java.text.DateFormat df = new java.text.SimpleDateFormat("yyyyMMddhhmmss"); %>
<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%java.text.DateFormat df3 = new java.text.SimpleDateFormat("dd/MM/yyyy"); %>
<%

    /**
     * Captura de Ordenes de compra por ISEM
     */
    DecimalFormat formatter = new DecimalFormat("#,###,###");
    DecimalFormat formatter2 = new DecimalFormat("#,###,###.##");
    DecimalFormat formNoCom = new DecimalFormat("000");
    DecimalFormatSymbols custom = new DecimalFormatSymbols();
    custom.setDecimalSeparator('.');
    custom.setGroupingSeparator(',');
    formatter.setDecimalFormatSymbols(custom);
    HttpSession sesion = request.getSession();
    String usua = "";
    if (sesion.getAttribute("Usuario") != null) {
        usua = (String) sesion.getAttribute("Usuario");
    } else {
        response.sendRedirect("indexIsem.jsp");
    }
    ConectionDB con = new ConectionDB();
    ConectionDB_Linux conLinux = new ConectionDB_Linux();
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

    if (NoCompra == null || NoCompra.equals("")) {
        System.out.println("***" + NoCompra);
        try {
            con.conectar();
            int banIndice = 0;
            /*
             * Se busca que la orden de compra esté incompleta para continuar
             * Los Status son: En el campo F_StsPed de la tabla tb_pedidoisem
             * 0 En captura
             * 1 Eliminado
             * 2 Finalizado
             */
            ResultSet rset = con.consulta("select MAX(F_NoCompra) as F_NoCompra, F_StsPed from tb_pedidoisem where F_IdUsu='" + usua + "'");
            while (rset.next()) {
                if (rset.getInt("F_StsPed") == 0) {//Si el STATUS es 0 quiere decir que está incompleta
                    NoCompra = rset.getString("F_NoCompra");
                    banIndice = 1;
                }
            }
            System.out.println(NoCompra + "---");
            if (NoCompra == null || NoCompra.equals("")) {
                rset = con.consulta("select MAX(F_NoCompra) as F_NoCompra from tb_pedidoisem");
                int F_IndIsem = 0, maxIndice = 0;
                while (rset.next()) {
                    String NoMax[] = rset.getString(1).split("-");
                    maxIndice = Integer.parseInt(NoMax[0]);
                }
                rset = con.consulta("select F_IndIsem from tb_indice");
                while (rset.next()) {
                    F_IndIsem = rset.getInt("F_IndIsem");
                }

                /*
                 * Hacer mejora, que no se incremente cuando no se captura orden de compra;
                 */
                NoCompra = indice.noCompra();
                NoCompra = formNoCom.format(Integer.parseInt(NoCompra)) + "-2015";
                sesion.setAttribute("NoCompra", NoCompra);
            }
            con.cierraConexion();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    int ExiLot = 0;
    Double NIM = 0.0;
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>ISEM</title>
        <!-- Estilos CSS -->
        <link href="css/bootstrap.css" rel="stylesheet">
        <link href="css/datepicker3.css" rel="stylesheet">
        <link rel="stylesheet" href="css/cupertino/jquery-ui-1.10.3.custom.css" />
        <!--link href="css/navbar-fixed-top.css" rel="stylesheet"-->
        <!---->
        <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->

    </head>
    <body onload="focusLocus();
            SelectProve(FormBusca);">
        <div class="container">
            <h3>ISEM - Captura de Entregas</h3>
            <div class="row">
                <div class="col-sm-11">
                    <a class="btn btn-default" href="capturaISEM.jsp">Captura de Órdenes de Compra</a>
                    <a class="btn btn-default" href="verFoliosIsem.jsp">Ver Órdenes de Compra</a>
                </div>
                <div class="col-sm-1">
                    <a class="btn btn-danger" href="indexIsem.jsp">Salir</a>
                </div>
            </div>
            <hr/>
            <form name="FormBusca" action="CapturaPedidos" method="post">
                <div class="row">
                    <h5 class="col-sm-3 col-sm-offset-7 text-right">Número de Orden de Compra</h5>
                    <div class="col-sm-2">
                        <input type="text" class="form-control input-sm" id="NoCompra" name="NoCompra" value="<%=NoCompra%>" readonly=""  />
                    </div>
                </div>
                <br/>
                <div class="row">
                    <label class="col-sm-1">
                        <h4>Proveedor:</h4>
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
                        <h4>Fecha de Entrega:</h4>
                    </label>
                    <div class="col-sm-2">
                        <input type="date" class="form-control" id="Fecha" name="Fecha" value="<%=fecEnt%>" onchange="document.getElementById('Hora').focus()" />
                    </div>
                    <label class="col-sm-2">
                        <h4>Hora de Entrega:</h4>
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
                        <h4>Clave:</h4>
                    </label>
                    <div class="col-sm-2">
                        <!--input type="text" class="form-control" id="Clave" name="Clave" /-->
                        <select name="Clave" id="Clave" class="form-control">
                            <option>-- Seleccione --</option>
                        </select>
                    </div>
                    <div class="col-sm-1">
                        <button class="btn btn-primary btn-block" onclick="return validaClaDes(this);" name="accion" value="Clave">Clave</button>
                    </div>

                </div>
            </form>
            <br/>
            <form name="FormCaptura" action="CapturaPedidos" method="post">
                <div class="panel panel-default">
                    <div class="panel-body">
                        <div class="row">
                            <label class="col-sm-1 text-right">
                                <h4>Clave:</h4>
                            </label>
                            <div class="col-sm-2">
                                <input type="text" class="form-control" readonly value="<%=claPro%>" name="ClaPro" id="ClaPro"/>
                            </div>
                            <label class="col-sm-1">
                                <h4>Descripción:</h4>
                            </label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" readonly value="<%=desPro%>" name="DesPro" id="DesPro"/>
                            </div>
                        </div>
                        <%

                            int meses = 0;
                            int banNIM = 0;
                            try {
                                /**
                                 * Se obtiene la información de la clave a
                                 * capturar
                                 */
                                con.conectar();
                                ResultSet rset = con.consulta("select pp.F_CantMax, pp.F_CantMin, m.F_PrePro from tb_prodprov pp, tb_medica m where m.F_ClaPro = pp.F_ClaPro and pp.F_ClaPro = '" + claPro + "' and pp.F_ClaProve='" + proveedor + "' ");
                                while (rset.next()) {
                                    int cantUsada = 0;
                                    int cantMax = 0;
                                    double totalClave = 0, remisionadoClave = 0, CPM = 0, CPCM2014 = 0, invMen2014 = 0;
                                    cantMax = rset.getInt(1);
                                    /**
                                     * Pedido anteriormente
                                     */
                                    ResultSet rset2 = con.consulta("select sum(F_Cant) from tb_pedidoisem where F_Clave='" + claPro + "' and F_Provee='" + proveedor + "' and F_StsPed !='2' and F_NoCompra like '%-2015%'");
                                    while (rset2.next()) {
                                        cantUsada = rset2.getInt(1);
                                    }
                                    int cantRestante = cantMax - cantUsada;

                                    /**
                                     * Saber a que catálogo pertenece. NO SE USA
                                     */
                                    String catalogo = "2014";
                                    rset2 = con.consulta("select F_ClaPro from tb_cat2015 where F_ClaPro = '" + claPro + "'");
                                    while (rset2.next()) {
                                        catalogo = "2015";
                                    }

                                    /**
                                     * Si es de ambos catálogos
                                     */
                                    rset2 = con.consulta("select t1.F_ClaPro from tb_cat2015 t1, tb_cat2014 t2 where t1.F_ClaPro = t2.F_ClaPro and t1.F_ClaPro = '" + claPro + "'");
                                    while (rset2.next()) {
                                        catalogo = "2014/2015";
                                    }

                                    int difd = 0, difd2 = 0;
                                    rset2 = con.consulta("select datediff( now(), F_FecCarg ) as dias from tb_unireq where F_ClaPro='" + claPro + "' LIMIT 1;");
                                    while (rset2.next()) {
                                        difd2 = rset2.getInt(1);
                                    }

                                    rset2 = con.consulta("select datediff( now(), F_FecMov ) as dias from tb_movinv where F_ProMov='" + claPro + "' LIMIT 1;");
                                    while (rset2.next()) {
                                        difd = rset2.getInt(1);
                                    }
                                    /**
                                     * Se calculan lo días de diferencia como en
                                     * el ASF
                                     */
                                    if (difd2 > difd) {
                                        difd = difd2;
                                    }

                                    /**
                                     * Calculo de existencias quitando lo
                                     * apartado
                                     */
                                    int F_ExiLot = 0;
                                    rset2 = con.consulta("select (F_ExiLot) as F_ExiLot from tb_lote where F_ClaPro = '" + claPro + "' and F_ExiLot!=0 union all select -F_Cant from clavefact where F_ClaPro = '" + claPro + "' and F_StsFact<5");
                                    while (rset2.next()) {
                                        F_ExiLot += rset2.getInt("F_ExiLot");

                                    }

                                    /**
                                     * Total del remisionado por clave
                                     */
                                    ExiLot = F_ExiLot;
                                    rset2 = con.consulta("select SUM(F_CantSur) as F_CantSur from tb_factura where F_ClaPro = '" + claPro + "' and F_StsFact='A'  ");
                                    while (rset2.next()) {
                                        remisionadoClave = rset2.getDouble("F_CantSur");
                                    }

                                    /**
                                     * Calculo del ASF
                                     */
                                    if (remisionadoClave > 0) {
                                        CPM = (remisionadoClave / difd) * 30;
                                        NIM = (double) F_ExiLot / CPM;
                                    }
                                    banNIM = 1;

                                    rset2 = con.consulta("select TIMESTAMPDIFF(month, now(), '2016-02-01' ) as meses;");
                                    while (rset2.next()) {
                                        meses = rset2.getInt(1);
                                    }
                        %>
                        <div class="row">
                            <label class="col-sm-2 text-right">
                                <h4>Cantidad Enviada:</h4>
                            </label>
                            <div class="col-sm-2">
                                <input type="text" class="form-control" readonly value="<%=formatter.format(cantUsada)%>" name="" id=""/>
                            </div>
                            <label class="col-sm-2">
                                <h4>Cantidad Máxima:</h4>
                            </label>
                            <div class="col-sm-2">
                                <input type="text" class="form-control" readonly value="<%=formatter.format(cantMax)%>" name="" id=""/>
                            </div>
                            <label class="col-sm-2 text-right">
                                <h4>Cantidad Restante:</h4>
                            </label>
                            <div class="col-sm-2">
                                <input type="text" class="form-control" readonly value="<%=formatter.format(cantRestante)%>" name="CantRest" id="CantRest"/>
                            </div>
                        </div>
                        <div class="row">
                            <label class="col-sm-2">
                                <h4>Presentación</h4>
                            </label>
                            <div class="col-sm-10">
                                <input type="text" class="form-control" readonly value="<%=rset.getString(3)%>" name="" id=""/>
                            </div>
                        </div>
                        <%
                                }
                                con.cierraConexion();
                            } catch (Exception e) {
                                out.println(e);
                            }
                        %>


                        <div class="row">
                            <label class="col-sm-2 text-center">
                                <h4>Exist. en Almacén:</h4>
                            </label>
                            <div class="col-sm-2">
                                <input type="text" class="form-control" name="CantAlm" id="CantAlm" readonly="" value="<%=formatter.format((ExiLot))%>" />
                            </div>
                            <label class="col-sm-2 text-center">
                                <h4>No. de Entrega:</h4>
                            </label>
                            <div class="col-sm-2">
                                <select  class="form-control" name="Prioridad" id="Prioridad" onchange="document.getElementById('CanPro').focus()" >
                                    <option selected="">1-2015</option>
                                    <option>2-2015</option>
                                    <option>3-2015</option>
                                    <option>4-2015</option>
                                    <option>5-2015</option>
                                    <option>6-2015</option>
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
                            </div><label class="col-sm-2 text-right">
                                <h4>Pzs a Entregar:</h4>
                            </label>
                            <div class="col-sm-2">
                                <input type="text" class="form-control" name="CanPro" id="CanPro" onKeyPress="return justNumbers(event);" />
                            </div>
                        </div>
                        <div class="alert
                             <%
                                 if (banNIM == 1) {
                                     if (NIM == 0) {
                                         out.println("alert-danger");
                                     } else if (NIM > meses) {
                                         out.println("alert-info");
                                     }                                  %>
                             ">

                            <%
                                    if (NIM == 0) {
                                        out.println("Agotada:");
                                    } else if (NIM > meses) {
                                        out.println("Sobre Abasto:");
                                    }
                                }
                            %>


                            Meses de Inventario <%=formatter2.format(NIM)%>
                        </div>
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
                    <td><strong>Fecha</strong></td>
                    <td><strong>Hora</strong></td>
                    <td><strong>Cantidad</strong></td>
                    <td></td>
                </tr>
                <%
                    int banConfirma = 0;
                    try {
                        con.conectar();
                        ResultSet rset = con.consulta("select s.F_Clave, m.F_DesPro, s.F_Lote, DATE_FORMAT(F_Cadu, '%d/%m/%Y'), s.F_Cant, F_IdIsem, DATE_FORMAT(F_FecSur, '%d/%m/%Y'), F_HorSur from tb_pedidoisem s, tb_medica m where s.F_Clave = m.F_ClaPro and F_IdUsu = '" + (String) sesion.getAttribute("Usuario") + "' and F_NoCompra = '" + NoCompra + "' and F_StsPed = '0' ");
                        while (rset.next()) {
                            banConfirma = 1;
                %>
                <tr>
                    <td><%=rset.getString(1)%></td>
                    <td><%=rset.getString(2)%></td>
                    <td><%=rset.getString(7)%></td>
                    <td><%=rset.getString(8)%></td>
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
                <%
                    if (banConfirma == 1) {
                %>
                <form name="FormCaptura" action="CapturaPedidos" method="post">
                    <div class="col-sm-6">
                        <input class="hidden" name="NoCompra" value="<%=NoCompra%>"/>
                        <button class="btn btn-success btn-block" name="accion" value="confirmar" onclick="return confirm('¿Seguro que desea CONFIRMAR el pedido?')">Confirmar Orden de Compra</button>
                    </div>
                    <div class="col-sm-6">
                        <button class="btn btn-danger btn-block" name="accion" value="cancelar" onclick="return confirm('¿Seguro que desea CANCELAR el pedido?')">Limpiar Pantalla</button>
                    </div>
                </form>
                <%
                    }
                %>
            </div>
        </div>
        <script type="text/javascript" src="js/jquery-1.9.1.js"></script>
        <script type="text/javascript" src="js/bootstrap.js"></script>
        <script type="text/javascript" src="js/jquery-ui-1.10.3.custom.js"></script>
        <script type="text/javascript" src="js/bootstrap-datepicker.js"></script>


        <script type="text/javascript">

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

                            /*$(function() {
                             $("#Fecha1").datepicker();
                             $("#Fecha1").datepicker('option', {dateFormat: 'dd/mm/yy'});
                             });*/
                            $(function() {
                                /**
                                 * Para hacer tipo datepicker a los inputs
                                 */
                                $("#CadPro").datepicker();
                                $("#CadPro").datepicker('option', {dateFormat: 'dd/mm/yy'});
                            });



                            function validaClaDes(boton) {
                                /**
                                 * 
                                 * @type @exp;boton@pro;value
                                 * 
                                 * Valida el boton
                                 */
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
                                /**
                                 * 
                                 * @type @exp;document@call;getElementById@pro;value
                                 * 
                                 * Valida las capturas
                                 */
                                var ClaPro = document.getElementById('ClaPro').value;
                                var DesPro = document.getElementById('DesPro').value;
                                var CanPro = document.getElementById('CanPro').value;
                                if (ClaPro === "" || DesPro === "" || CanPro === "") {
                                    alert("Complete los datos");
                                    return false;
                                }
                                var CanRes = document.getElementById('CantRest').value;
                                CanRes = CanRes.replace(",", "");
                                CanRes = CanRes.replace(",", "");
                                CanRes = CanRes.replace(",", "");
                                CanRes = CanRes.replace(",", "");
                                CanRes = CanRes.replace(",", "");
                                if (parseInt(CanRes) < parseInt(CanPro)) {
                                    alert("La Cantidad Solicitada no puede ser mayor a la Cantidad Restante");
                                    return false;
                                }

                                return true;
                            }


                            function SelectProve(form) {
                                /**
                                 * Para armar las claves dependiendo del proveedor seleccionado
                                 */
            <%
                try {
                    con.conectar();
                    ResultSet rset3 = con.consulta("select DISTINCT F_ClaProve from tb_prodprov");
                    while (rset3.next()) {
                        out.println("if (form.Proveedor.value == '" + rset3.getString(1) + "') {");
                        out.println("var select = document.getElementById('Clave');");
                        out.println("select.options.length = 0;");
                        int i = 1;
                        ResultSet rset4 = con.consulta("select F_ClaPro from tb_prodprov where F_ClaProve = '" + rset3.getString(1) + "' order by F_ClaPro asc");

                        out.println("select.options[select.options.length] = new Option('-Seleccione-', '');");
                        while (rset4.next()) {
                            out.println("select.options[select.options.length] = new Option('" + rset4.getString(1) + "', '" + rset4.getString(1) + "');");
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
    </body>

</html>
