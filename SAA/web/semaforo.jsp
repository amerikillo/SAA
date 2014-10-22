<%-- 
    Document   : exist
    Created on : 02-jul-2014, 23:24:11
    Author     : wence
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
    DecimalFormat formatter2 = new DecimalFormat("#,###,###.##");
    DecimalFormatSymbols custom = new DecimalFormatSymbols();
    custom.setDecimalSeparator(',');
    formatter.setDecimalFormatSymbols(custom);
    HttpSession sesion = request.getSession();
    String usua = "ISEM", Clave = "1", Claves = "", Kardex = "";
    ResultSet rset;
    ResultSet rset2;
    int Cantidad = 0;
    double monto = 0, montof = 0;

    /*if (sesion.getAttribute("nombre") != null) {
     usua = (String) sesion.getAttribute("nombre");
     Clave = (String) session.getAttribute("clave");
     } else {
     response.sendRedirect("index.jsp");
     }
     if (Clave== null){
     Clave="";
     }*/
    ConectionDB con = new ConectionDB();
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- Estilos CSS -->
        <link href="css/bootstrap.css" rel="stylesheet">
        <link href="css/datepicker3.css" rel="stylesheet">
        <link rel="stylesheet" href="css/cupertino/jquery-ui-1.10.3.custom.css" />
        <link href="css/navbar-fixed-top.css" rel="stylesheet">
        <link href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap-glyphicons.css" rel="stylesheet">
        <link href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css" rel="stylesheet">
        <script src="//netdna.bootstrapcdn.com/bootstrap/3.0.0/js/bootstrap.min.js"></script>
        <!---->
        <title>Ingresos en Almac&eacute;n</title>



    </head>
    <body>
        <div class="container">
            <h1>SIALSS</h1>
            <h4>SISTEMA INTEGRAL DE ADMINISTRACIÓN Y LOGÍSTICA PARA SERVICIOS DE SALUD</h4>
            <!--div class="navbar navbar-default">
                <div class="container">
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
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
                                    <li><a href="captura.jsp">Entrada Manual</a></li>
                                    <li><a href="compraAuto2.jsp">Entrada Automática OC ISEM</a></li>
                                    <li><a href="reimpresion.jsp">Reimpresión de Compras</a></li>
                                    <li><a href="ordenesCompra.jsp">Órdenes de Compras</a></li>
                                    <li><a href="kardexClave.jsp">Kardex Claves</a></li>
                                    <li><a href="Ubicaciones/Consultas.jsp">Ubicaciones</a></li>
                                </ul>
                            </li>
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Facturación<b class="caret"></b></a>
                                <ul class="dropdown-menu">
                                    <li><a href="requerimiento.jsp">Carga de Requerimiento</a></li>
                                    <li><a href="factura.jsp">Facturación Automática</a></li>
                                     <li><a href="reimp_factura.jsp">Administrar Remisiones</a></li>
                                </ul>
                            </li>
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Catálogos<b class="caret"></b></a>
                                <ul class="dropdown-menu">
                                    <li><a href="medicamento.jsp">Catálogo de Medicamento</a></li>
                                    <li><a href="catalogo.jsp">Catálogo de Proveedores</a></li>
                                    <li><a href="marcas.jsp">Catálogo de Marcas</a></li>
                                </ul>
                            </li>
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Fecha Recibo<b class="caret"></b></a>
                                <ul class="dropdown-menu">
                                    <li><a href="Entrega.jsp">Fecha de Recibo en CEDIS</a></li>     
                                    <li><a href="historialOC.jsp">Historial OC</a></li>                                  
                                </ul>
                            </li>
            <!--li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">ADASU<b class="caret"></b></a>
                <ul class="dropdown-menu">
                    <li><a href="../captura.jsp">Captura de Insumos</a></li>
                    <li class="divider"></li>
                    <li><a href="../catalogo.jsp">Catálogo de Proveedores</a></li>
                    <li><a href="../reimpresion.jsp">Reimpresión de Docs</a></li>
                </ul>
            </li>
            
        </ul>
        <ul class="nav navbar-nav navbar-right">
            <li><a href=""><span class="glyphicon glyphicon-user"></span> <%=usua%></a></li>
            <li class="active"><a href="index.jsp"><span class="glyphicon glyphicon-log-out"></span></a></li>
        </ul>
    </div><!--/.nav-collapse >
</div>
</div-->
            <hr/>
        </div>
        <div class="container">
            <form action="semaforo.jsp" method="post">
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <h3 class="panel-title">Semaforización
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<!--input type="text" name="clave" id="clave" placeholder="Clave" > <button class="btn btn-sm btn-success" id="btn-buscar2">BUSCAR&nbsp;<label class="glyphicon glyphicon-search"></label></button-->&nbsp;&nbsp;&nbsp;<input type="checkbox" name="kardex" id="kardex" value="1" onchange="this.form.submit();" /> Menor a 9 Meses&nbsp;&nbsp;&nbsp;<input type="checkbox" name="kardex" id="kardex" value="2" onchange="this.form.submit();" /> Entre 9 y 12 Meses&nbsp;&nbsp;&nbsp;<input type="checkbox" name="kardex" id="kardex" value="3" onchange="this.form.submit();" />Mayor a 12 Meses <!--a href="gnr.jsp">Descargar<label class="glyphicon glyphicon-download"></label></a-->&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="semaforo.jsp">Actualizar<label class="glyphicon glyphicon-refresh"></label></a></h3>
                    </div>

                    <div class="panel-footer">
                        <table cellpadding="0" cellspacing="0" border="0" class="table table-striped table-bordered" id="datosProv">
                            <thead>
                                <tr>
                                    <td>Clave</td>
                                    <td>Descripción</td>
                                    <td>Lote</td>
                                    <td>Caducidad</td>                                
                                    <td>Cantidad</td>
                                    <td>Costo U.</td>
                                    <td>Monto</td>
                                    <td>Semaforización</td>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try {
                                        con.conectar();
                                        Kardex = request.getParameter("kardex");

                                        if (Kardex.equals("1")) {
                                            rset = con.consulta("SELECT l.F_ClaPro, m.F_DesPro, l.F_ClaLot, DATE_FORMAT(l.F_FecCad, '%d/%m/%Y') AS F_FecCad, SUM(F_ExiLot), (m.F_Costo*l.F_ExiLot) as monto,m.F_Costo FROM tb_lote l, tb_medica m, tb_ubica u WHERE m.F_ClaPro = l.F_ClaPro AND l.F_Ubica = u.F_ClaUbi AND F_ExiLot != 0 AND F_FecCad < DATE_ADD(CURDATE(), INTERVAL 9 MONTH) GROUP BY l.F_ClaPro,l.F_ClaLot,l.F_FecCad");
                                        } else if (Kardex.equals("2")) {
                                            rset = con.consulta("SELECT l.F_ClaPro, m.F_DesPro, l.F_ClaLot, DATE_FORMAT(l.F_FecCad, '%d/%m/%Y') AS F_FecCad, SUM(F_ExiLot), (m.F_Costo*l.F_ExiLot) as monto,m.F_Costo FROM tb_lote l, tb_medica m, tb_ubica u WHERE m.F_ClaPro = l.F_ClaPro AND l.F_Ubica = u.F_ClaUbi AND F_ExiLot != 0 AND F_FecCad BETWEEN DATE_ADD(CURDATE(), INTERVAL 9 MONTH DAY) AND DATE_ADD(CURDATE(), INTERVAL 12 MONTH) GROUP BY l.F_ClaPro,l.F_ClaLot,l.F_FecCad");
                                        } else {
                                            rset = con.consulta("SELECT l.F_ClaPro, m.F_DesPro, l.F_ClaLot, DATE_FORMAT(l.F_FecCad, '%d/%m/%Y') AS F_FecCad, SUM(F_ExiLot), (m.F_Costo*l.F_ExiLot) as monto,m.F_Costo FROM tb_lote l, tb_medica m, tb_ubica u WHERE m.F_ClaPro = l.F_ClaPro AND l.F_Ubica = u.F_ClaUbi AND F_ExiLot != 0 AND F_FecCad > DATE_ADD(CURDATE(), INTERVAL 12 MONTH) GROUP BY l.F_ClaPro,l.F_ClaLot,l.F_FecCad");
                                        }
                                        while (rset.next()) {
                                %>
                                <tr>
                                    <td><%=rset.getString(1)%></td>
                                    <td><%=rset.getString(2)%></td>
                                    <td><%=rset.getString(3)%></td>
                                    <td><%=rset.getString(4)%></td>
                                    <td><%=formatter.format(rset.getInt(5))%></td>
                                    <td><%=formatter2.format(rset.getDouble(7))%></td>
                                    <td><%=formatter2.format(rset.getDouble(6))%></td>
                                    <%if (Kardex.equals("1")) {%>

                                    <td><span class="label label-danger">Menor 9 Meses</span></td>

                                    <%} else if (Kardex.equals("2")) {%>

                                    <td><span class="label label-warning">Entre 9 y 12 Meses</span></td>

                                    <%} else if (Kardex.equals("3")) {%>

                                    <td><span class="label label-success">Mayor a 12 Meses</span></td>
                                    <%} else {%>
                                    <td><span class="label label-success"> Mayor a 12 Meses</span></td>
                                    <%}%>


                                </tr>
                                <%
                                        }
                                        if (Kardex.equals("1")) {
                                            rset2 = con.consulta("SELECT SUM(F_ExiLot),sum((m.F_Costo*l.F_ExiLot)) as monto FROM tb_lote l INNER JOIN tb_medica m on l.F_ClaPro=m.F_ClaPro where F_FecCad < DATE_ADD(CURDATE(), INTERVAL 270 DAY)");
                                        } else if (Kardex.equals("2")) {
                                            rset2 = con.consulta("SELECT SUM(F_ExiLot),sum((m.F_Costo*l.F_ExiLot)) as monto FROM tb_lote l INNER JOIN tb_medica m on l.F_ClaPro=m.F_ClaPro where F_FecCad BETWEEN DATE_ADD(CURDATE(), INTERVAL 271 DAY) AND DATE_ADD(CURDATE(), INTERVAL 365 DAY)");
                                        } else {
                                            rset2 = con.consulta("SELECT SUM(F_ExiLot),sum((m.F_Costo*l.F_ExiLot)) as monto FROM tb_lote l INNER JOIN tb_medica m on l.F_ClaPro=m.F_ClaPro where F_FecCad > DATE_ADD(CURDATE(), INTERVAL 365 DAY)");
                                        }
                                        while (rset2.next()) {
                                            Cantidad = Integer.parseInt(rset2.getString(1));
                                            monto = Double.parseDouble(rset2.getString(2));
                                        }
                                        con.cierraConexion();
                                    } catch (Exception e) {
                                        System.out.println(e.getMessage());
                                    }
                                %>
                            </tbody>

                        </table><h3>Total Piezas = <%=formatter.format(Cantidad)%>&nbsp;&nbsp;&nbsp;Monto Total = $<%=formatter2.format(monto)%></h3>
                    </div>
                </div>
            </form>
        </div>
        <br><br><br>
        <div class="navbar navbar-fixed-bottom navbar-inverse">
            <div class="text-center text-muted">
                GNK Logística || Desarrollo de Aplicaciones 2009 - 2014 <span class="glyphicon glyphicon-registration-mark"></span><br />
                Todos los Derechos Reservados
            </div>
        </div>
    </body>
</html>


<!-- 
================================================== -->
<!-- Se coloca al final del documento para que cargue mas rapido -->
<!-- Se debe de seguir ese orden al momento de llamar los JS -->
<script src="js/jquery-1.9.1.js"></script>
<script src="js/bootstrap.js"></script>
<script src="js/jquery-ui-1.10.3.custom.js"></script>
<script src="js/jquery.dataTables.js"></script>
<script src="js/dataTables.bootstrap.js"></script>
<script src="js/bootstrap-datepicker.js"></script>
<script>
                            $(document).ready(function() {
                                $('#datosProv').dataTable();
                            });
</script>
<script>


    function isNumberKey(evt, obj)
    {
        var charCode = (evt.which) ? evt.which : event.keyCode;
        if (charCode === 13 || charCode > 31 && (charCode < 48 || charCode > 57)) {
            if (charCode === 13) {
                frm = obj.form;
                for (i = 0; i < frm.elements.length; i++)
                    if (frm.elements[i] === obj)
                    {
                        if (i === frm.elements.length - 1)
                            i = -1;
                        break
                    }
                /*ACA ESTA EL CAMBIO*/
                if (frm.elements[i + 1].disabled === true)
                    tabular(e, frm.elements[i + 1]);
                else
                    frm.elements[i + 1].focus();
                return false;
            }
            return false;
        }
        return true;

    }

    function valida_clave() {
        var missinginfo = "";
        if ($("#Nombre").val() == "") {
            missinginfo += "\n El campo Clave de la Unidad no debe de estar vacío";
        }
        if (missinginfo != "") {
            missinginfo = "\n TE HA FALTADO INTRODUCIR LOS SIGUIENTES DATOS PARA ENVIAR PETICIÓN DE SOPORTE:\n" + missinginfo + "\n\n ¡INGRESA LOS DATOS FALTANTES Y TRATA OTRA VEZ!\n";
            alert(missinginfo);
            return false;
        } else {
            return true;
        }
    }

    function valida_alta() {
        var missinginfo = "";
        if ($("#Nombre").val() == "") {
            missinginfo += "\n El campo Clave de la Unidad no debe de estar vacío";
        }
        if ($("#FecFab").val() == "") {
            missinginfo += "\n El campo Fecha Entrega no debe de estar vacío";
        }
        if (missinginfo != "") {
            missinginfo = "\n TE HA FALTADO INTRODUCIR LOS SIGUIENTES DATOS PARA ENVIAR PETICIÓN DE SOPORTE:\n" + missinginfo + "\n\n ¡INGRESA LOS DATOS FALTANTES Y TRATA OTRA VEZ!\n";
            alert(missinginfo);

            return false;
        } else {

            return true;
        }
    }
</script>
<script language="javascript">
    function justNumbers(e)
    {
        var keynum = window.event ? window.event.keyCode : e.which;
        if ((keynum == 8) || (keynum == 46))
            return true;

        return /\d/.test(String.fromCharCode(keynum));
    }
    otro = 0;
    function LP_data() {
        var key = window.event.keyCode;//codigo de tecla. 
        if (key < 48 || key > 57) {//si no es numero 
            window.event.keyCode = 0;//anula la entrada de texto. 
        }
    }
    function anade(esto) {
        if (esto.value.length === 0) {
            if (esto.value.length == 0) {
                esto.value += "(";
            }
        }
        if (esto.value.length > otro) {
            if (esto.value.length == 4) {
                esto.value += ") ";
            }
        }
        if (esto.value.length > otro) {
            if (esto.value.length == 9) {
                esto.value += "-";
            }
        }
        if (esto.value.length < otro) {
            if (esto.value.length == 4 || esto.value.length == 9) {
                esto.value = esto.value.substring(0, esto.value.length - 1);
            }
        }
        otro = esto.value.length
    }


    function tabular(e, obj)
    {
        tecla = (document.all) ? e.keyCode : e.which;
        if (tecla != 13)
            return;
        frm = obj.form;
        for (i = 0; i < frm.elements.length; i++)
            if (frm.elements[i] == obj)
                /*ACA ESTA EL CAMBIO*/
                if (frm.elements[i + 1].disabled == true)
                    tabular(e, frm.elements[i + 1]);
                else
                    frm.elements[i + 1].focus();
        return false;
    }

    $(function() {
        $("#FecFab").datepicker();
        $("#FecFab").datepicker('option', {dateFormat: 'dd/mm/yy'});
    });
</script> 


