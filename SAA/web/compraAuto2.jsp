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

    HttpSession sesion = request.getSession();
    String usua = "";
    if (sesion.getAttribute("nombre") != null) {
        usua = (String) sesion.getAttribute("nombre");
    } else {
        response.sendRedirect("index.jsp");
    }
    ConectionDB con = new ConectionDB();
    String fecha = "", noCompra = "", Proveedor = "";
    try {
        fecha = request.getParameter("Fecha");
    } catch (Exception e) {
    }
    try {
        noCompra = request.getParameter("NoCompra");
        //System.out.println(noCompra);
    } catch (Exception e) {
    }
    try {
        Proveedor = request.getParameter("Proveedor");
    } catch (Exception e) {
    }
    if (fecha == null) {
        fecha = "";
    }
    if (noCompra == null) {
        try {
            noCompra = (String) sesion.getAttribute("NoCompra");
        } catch (Exception e) {
        }
        if (noCompra == null) {
            noCompra = "";
        }
    }
    System.out.println(noCompra);
    if (Proveedor == null) {
        Proveedor = "";
    }

    String posClave = "0";
    try {
        posClave = sesion.getAttribute("posClave").toString();
    } catch (Exception e) {

    }
    if (posClave == null || posClave.equals("")) {
        posClave = "0";
    }

    try {
        if (request.getParameter("accion").equals("buscaCompra")) {
            posClave = "0";
        }
    } catch (Exception e) {

    }

    int numRenglones = 0;

    String folioRemi = "";
    try {
        folioRemi = (String) sesion.getAttribute("folioRemi");
    } catch (Exception e) {
    }
    if (folioRemi == null) {
        folioRemi = "";
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                        <a class="navbar-brand" href="main_menu.jsp">Inicio</a>
                    </div>
                    <div class="navbar-collapse collapse">
                        <ul class="nav navbar-nav">
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">SAA<b class="caret"></b></a>
                                <ul class="dropdown-menu">
                                    <li><a href="captura.jsp">Captura Manual</a></li>
                                    <li><a href="compraAuto2.jsp">Captura Automática</a></li>
                                    <!--li><a href="captura_handheld.jsp">Captura de Insumos handheld</a></li-->
                                    <li><a href="factura.jsp">Facturación Automática</a></li>
                                    <li><a href="requerimiento.jsp">Carga de Requerimiento</a></li>
                                    <li class="divider"></li>
                                    <li><a href="medicamento.jsp">Catálogo de Medicamento</a></li>
                                    <li><a href="catalogo.jsp">Catálogo de Proveedores</a></li>
                                    <li><a href="marcas.jsp">Catálogo de Marcas</a></li>
                                    <li><a href="reimpresion.jsp">Reimpresión de Compras</a></li>
                                    <li><a href="reimp_factura.jsp">Reimpresión de Facturas</a></li>
                                    <li class="divider"></li>
                                    <li><a href="Ubicaciones/Consultas.jsp">Ubicaciones</a></li>

                                </ul>
                            </li>
                            <!--li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">ADASU<b class="caret"></b></a>
                                <ul class="dropdown-menu">
                                    <li><a href="captura.jsp">Captura de Insumos</a></li>
                                    <li class="divider"></li>
                                    <li><a href="catalogo.jsp">Catálogo de Proveedores</a></li>
                                    <li><a href="reimpresion.jsp">Reimpresión de Docs</a></li>
                                </ul>
                            </li-->
                            <%                                if (usua.equals("root")) {
                            %>
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Usuario<b class="caret"></b></a>
                                <ul class="dropdown-menu">
                                    <li><a href="usuarios/usuario_nuevo.jsp">Nuevo Usuario</a></li>
                                    <li><a href="usuarios/edita_usuario.jsp">Edicion de Usuarios</a></li>
                                </ul>
                            </li>
                            <%                                }
                            %>
                        </ul>
                        <ul class="nav navbar-nav navbar-right">
                            <li><a href=""><span class="glyphicon glyphicon-user"></span> <%=usua%></a></li>
                            <li class="active"><a href="index.jsp"><span class="glyphicon glyphicon-log-out"></span></a></li>
                        </ul>
                    </div><!--/.nav-collapse -->
                </div>
            </div>
            <form action="compraAuto2.jsp" method="post">
                <div class="row">
                    <label class="col-sm-2 text-right">
                        <h4>Número de Compra</h4>
                    </label>
                    <div class="col-sm-2">
                        <input type="text" class="form-control" id="NoCompra" name="NoCompra" value="<%=noCompra%>" />
                    </div>


                </div>

                <br/>
                <div class="row">
                    <div class="col-xs-12">
                        <button class="btn btn-block btn-primary" name="accion" value="buscaCompra">Buscar</button>
                    </div>
                </div>
            </form>
            <form action="CompraAutomatica" method="get">
                <br/>
                <%
                    try {
                        con.conectar();
                        ResultSet rset = con.consulta("select i.F_NoCompra, i.F_FecSur, i.F_HorSur, p.F_NomPro, p.F_ClaProve from tb_pedidoisem i, tb_proveedor p where i.F_Provee = p.F_ClaProve and F_StsPed = '1' and F_NoCompra = '" + noCompra + "' and F_recibido='0'  group by F_NoCompra");
                        while (rset.next()) {
                %>
                <div class="row">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <div class="row">
                                <h4 class="col-sm-1">Folio:</h4>
                                <div class="col-sm-2"><input class="form-control" value="<%=rset.getString(1)%>" readonly="" name="folio" id="folio" /></div>
                                <h4 class="col-sm-2 text-right">Folio de Remisión:</h4>
                                <div class="col-sm-2"><input class="form-control" value="<%=folioRemi%>" name="folioRemi" id="folioRemi" /></div>
                            </div>
                            <div class="row">
                                <h4 class="col-sm-12">Proveedor: <%=rset.getString(4)%></h4>
                            </div>
                            <div class="row">
                                <h4 class="col-sm-12">Fecha y Hora de Entrega: <%=df3.format(df2.parse(rset.getString(2)))%> <%=rset.getString(3)%></h4>
                            </div>
                        </div>
                        <div class="panel-body">

                            <%
                                try {
                                    con.conectar();
                                    ResultSet rset2 = con.consulta("select s.F_Clave, m.F_DesPro, s.F_Lote, DATE_FORMAT(F_Cadu, '%d/%m/%Y'), s.F_Cant, F_IdIsem, F_Obser from tb_pedidoisem s, tb_medica m where s.F_Clave = m.F_ClaPro and F_NoCompra = '" + rset.getString(1) + "' and F_StsPed = '1'");
                                    while (rset2.next()) {
                                        rset2.last();
                                        numRenglones = rset2.getRow() - 1;
                                    }
                                    rset2 = con.consulta("select s.F_Clave, m.F_DesPro, s.F_Lote, DATE_FORMAT(F_Cadu, '%d/%m/%Y'), s.F_Cant, F_IdIsem, F_Obser from tb_pedidoisem s, tb_medica m where s.F_Clave = m.F_ClaPro and F_NoCompra = '" + rset.getString(1) + "' and F_StsPed = '1' limit " + posClave + ",1 ");
                                    while (rset2.next()) {

                            %>
                            <h4 class="bg-primary" style="padding: 5px">CLAVE <%=Integer.parseInt(posClave) + 1%> / <%=numRenglones + 1%> | <%=rset2.getString(1)%> <%=rset2.getString(2)%></h4>
                            <table class="table table-bordered table-condensed table-striped">
                                <tr>
                                    <td><strong>Clave</strong></td>
                                    <td><strong>Descripción</strong></td>
                                    <td><strong>Cod Bar</strong></td>
                                    <td><strong>Lote</strong></td>
                                    <td><strong>Caducidad</strong></td>
                                    <td><strong>Cantidad Total</strong></td>
                                </tr>
                                <tr>
                                    <td><input type="text" value="<%=rset2.getString(1)%>" class="form-control" name="ClaPro" id="lot" onclick="" readonly=""/></td>
                                    <td><%=rset2.getString(2)%></td>
                                    <td>
                                        <input type="text" value="" class="form-control" name="codbar" id="codbar" onclick="" />
                                    </td>
                                    <td>
                                        <input type="text" value="<%=rset2.getString(3)%>" class="form-control" name="lot" id="lot" onkeypress="return tabular(event, this)" onclick=""/>
                                    </td>
                                    <td>
                                        <input type="text" value="<%=rset2.getString(4)%>" data-date-format="dd/mm/yyyy" class="form-control" name="cad" id="cad" onclick="" onKeyPress="
                                                return LP_data(event, this);
                                                anade(this, event);
                                                return tabular(event, this);
                                               " maxlength="10"/>
                                    </td>
                                    <td>
                                        <input type="text" value="<%=rset2.getString(5)%>" class="form-control" name="cant" id="cant" onclick="" readonly=""/>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <strong>Marca</strong>
                                        <select class="form-control" name="list_marca" onKeyPress="return tabular(event, this)" id="list_marca">
                                            <option value="">Marca</option>
                                            <%
                                                try {
                                                    con.conectar();
                                                    ResultSet rset3 = con.consulta("SELECT F_ClaMar,F_DesMar FROM tb_marca");
                                                    while (rset3.next()) {
                                            %>
                                            <option value="<%=rset3.getString("F_ClaMar")%>"><%=rset3.getString("F_DesMar")%></option>
                                            <%

                                                    }
                                                    con.cierraConexion();
                                                } catch (Exception e) {
                                                }
                                            %>
                                        </select>
                                        <input value="<%=rset.getString("p.F_ClaProve")%>" name="claPro" id="claPro" class="hidden" />
                                    </td>
                                    <td colspan="5">
                                        <strong>Observaciones</strong>
                                        <textarea class="form-control" readonly><%=rset2.getString(7)%></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6">
                                        <h5><strong>Tarimas Completas</strong></h5>
                                        <div class="row">

                                            <label for="Cajas" class="col-sm-2 control-label">Tarimas</label>
                                            <div class="col-sm-1">
                                                <input type="Cajas" class="form-control" id="TarimasC" name="TarimasC" placeholder="0" onKeyPress="return justNumbers(event);
                                                        return handleEnter(even);" onkeyup="totalPiezas" onclick="" />
                                            </div>
                                            <label for="pzsxcaja" class="col-sm-2 control-label">Cajas x Tarima</label>
                                            <div class="col-sm-1">
                                                <input type="pzsxcaja" class="form-control" id="CajasxTC" name="CajasxTC" placeholder="0" onKeyPress="return justNumbers(event);" onkeyup="totalPiezas()" onclick="" />
                                            </div>
                                            <label for="Resto" class="col-sm-2 control-label">Piezas x Caja</label>
                                            <div class="col-sm-1">
                                                <input type="Resto" class="form-control" id="PzsxCC" name="PzsxCC%>" placeholder="0" onKeyPress="return justNumbers(event);" onkeyup="totalPiezas()" onclick="" />
                                            </div>
                                        </div>
                                        <br/>
                                        <h5><strong>Tarimas Incompletas</strong></h5>
                                        <div class="row">

                                            <label for="Cajas" class="col-sm-2 control-label">Tarimas</label>
                                            <div class="col-sm-1">
                                                <input type="Cajas" class="form-control" id="TarimasI" name="TarimasI" placeholder="0" onKeyPress="return justNumbers(event);
                                                        return handleEnter(even);" onkeyup="totalPiezas();" onclick="" />
                                            </div>
                                            <label for="pzsxcaja" class="col-sm-2 control-label">Cajas x Tarima</label>
                                            <div class="col-sm-1">
                                                <input type="pzsxcaja" class="form-control" id="CajasxTI" name="CajasxTI" placeholder="0" onKeyPress="return justNumbers(event);" onkeyup="totalPiezas();" onclick=""/>
                                            </div>
                                            <label for="pzsxcaja" class="col-sm-2 control-label">Resto</label>
                                            <div class="col-sm-1">
                                                <input type="pzsxcaja" class="form-control" id="Resto" name="Resto" placeholder="0" onKeyPress="return justNumbers(event);" onkeyup="totalPiezas();" onclick=""/>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6">
                                        <h5><strong>Totales</strong></h5>
                                        <div class="row">

                                            <label for="Cajas" class="col-sm-2 control-label">Tarimas</label>
                                            <div class="col-sm-1">
                                                <input type="text" class="form-control" id="Tarimas" name="Tarimas" placeholder="0" readonly="" onKeyPress="return justNumbers(event);
                                                        return handleEnter(even);" onkeyup="totalPiezas();" onclick="" />
                                            </div>
                                            <label for="pzsxcaja" class="col-sm-2 control-label">Cajas</label>
                                            <div class="col-sm-1">
                                                <input type="text" class="form-control" id="Cajas" name="Cajas" placeholder="0" readonly="" onKeyPress="return justNumbers(event);" onkeyup="totalPiezas();" onclick=""/>
                                            </div>
                                            <label for="Resto" class="col-sm-2 control-label">Piezas</label>
                                            <div class="col-sm-2">
                                                <input type="text" class="form-control" id="Piezas" name="Piezas" placeholder="0" readonly="" onKeyPress="return justNumbers(event);" onkeyup="totalPiezas();" onclick="" />
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6">
                                        <textarea class="form-control" id="Obser" name="Obser"></textarea>
                                    </td>
                                </tr>
                            </table>
                            <div class="row">
                                <div class="col-sm-4">
                                    <%if (!posClave.equals("0")) {%>
                                    <button class="btn btn-block btn-danger" name="accion" id="accion" value="anterior" >Clave Anterior</button>
                                    <%}%>
                                </div>
                                <div class="col-sm-4">
                                    <button class="btn btn-block btn-primary" name="accion" id="accion" value="guardarLote" onclick="return validaCompra();" >Guardar Lote</button>
                                </div>
                                <div class="col-sm-4">
                                    <%if (!posClave.equals(numRenglones + "")) {%>
                                    <button class="btn btn-block btn-danger" name="accion" id="accion" value="siguiente" >Siguiente Clave</button>
                                    <%}%>

                                </div>
                            </div>


                            <hr/>
                            <%
                                    }
                                    con.cierraConexion();
                                } catch (Exception e) {
                                    out.println(e.getMessage());
                                }
                            %>
                        </div>
                        <!--div class="panel-footer">
                            <button class="btn btn-block btn-success btn-lg" name="accion" id="accion" value="confirmar" onclick="return validaCompra();">Confirmar Compra</button>
                        </div-->
                    </div>

                </div>
                <%
                        }
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                %>
            </form>

            <div class="panel-body panel-default">
                <table class="table table-bordered table-striped">
                    <tr>
                        <td><a name="ancla"></a>Código de Barras</td>
                        <td>Clave</td>
                        <td>Descripción</td>                       
                        <td>Lote</td>
                        <td>Caducidad</td>                        
                        <td>Existencia</td>
                        <td></td>
                    </tr>
                    <%
                        int banCompra = 0;
                        String obser = "";
                        try {
                            con.conectar();
                            ResultSet rset = con.consulta("SELECT C.F_Cb,C.F_ClaPro,M.F_DesPro,C.F_Lote,C.F_FecCad,C.F_Pz,F_IdCom FROM tb_compratemp C INNER JOIN tb_medica M ON C.F_ClaPro=M.F_ClaPro WHERE F_FecApl=CURDATE() AND F_User='" + usua + "'");
                            while (rset.next()) {
                                banCompra = 1;

                    %>
                    <tr>
                        <td><%=rset.getString(1)%></td>
                        <td><%=rset.getString(2)%></td>
                        <td><%=rset.getString(3)%></td>
                        <td><%=rset.getString(4)%></td>
                        <td><%=df3.format(df2.parse(rset.getString(5)))%></td>
                        <td><%=rset.getString(6)%></td>                        
                        <td>

                            <form method="get" action="Modificaciones">
                                <input name="id" type="text" style="" class="hidden" value="<%=rset.getString(7)%>" />
                                <button class="btn btn-warning" name="accion" value="modificarCompraAuto"><span class="glyphicon glyphicon-pencil" ></span></button>
                                <button class="btn btn-danger" onclick="return confirm('¿Seguro de que desea eliminar?');" name="accion" value="eliminarCompraAuto"><span class="glyphicon glyphicon-remove"></span>
                                </button>
                            </form>
                        </td>
                    </tr>
                    <%
                            }
                            con.cierraConexion();
                        } catch (Exception e) {

                        }
                    %>
                    <%
                        if (banCompra == 1) {
                    %>
                    <tr>

                        <td colspan="7">
                            <div class="col-lg-3 col-lg-offset-6">
                                <form action="nuevoAutomaticaLotes" method="post">
                                    <input name="fol_gnkl" type="text" style="" class="hidden" value="<%=noCompra%>" />
                                    <button  value="Eliminar" name="accion" class="btn btn-danger btn-block" onclick="return confirm('Seguro que desea eliminar la compra?');">Cancelar Compra</button>
                                </form>
                            </div>
                            <div class="col-lg-3">
                                <form action="nuevoAutomaticaLotes" method="post">
                                    <input name="fol_gnkl" type="text" style="" class="hidden" value="<%=noCompra%>" />
                                    <button  value="Guardar" name="accion" class="btn btn-success  btn-block" onclick="return confirm('Seguro que desea realizar la compra?');
                                            return validaCompra();">Confirmar Compra</button>
                                </form>
                            </div>
                            <!--div class="col-lg-3">
                                <form action="reimpReporte.jsp" target="_blank">
                                    <input class="hidden" name="fol_gnkl" value="<%=noCompra%>">
                                    <button class="btn btn-success btn-block">Imprimir Compra</button>
                                </form>
                            </div>
                            <div class="col-lg-3">
                                <form action="reimp_marbete.jsp" target="_blank">
                                    <input class="hidden" name="fol_gnkl" value="<%=noCompra%>">
                                    <button class="btn btn-primary btn-block">Imprimir Marbete</button>
                                </form>
                            </div-->
                        </td>
                        <!--td colspan="2"><a href="Reporte.jsp" target="_blank" class="btn btn-success btn-block">Imprimir</a></td-->
                    </tr>
                    <%
                        }
                    %>

                </table>

            </div>


        </div>


        <br><br><br>
        <div class="navbar navbar-inverse">
            <div class="text-center text-muted">
                GNK Logística || Desarrollo de Aplicaciones 2009 - 2014 <span class="glyphicon glyphicon-registration-mark"></span><br />
                Todos los Derechos Reservados
            </div>
        </div>
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
                                        function justNumbers(e)
                                        {
                                            var keynum = window.event ? window.event.keyCode : e.which;
                                            if ((keynum === 8) || (keynum === 46))
                                                return true;

                                            return /\d/.test(String.fromCharCode(keynum));
                                        }

                                        otro = 0;
                                        function LP_data(e, esto) {
                                            var key = (document.all) ? e.keyCode : e.which;//codigo de tecla. 
                                            if (key < 48 || key > 57)//si no es numero 
                                                return false;//anula la entrada de texto.
                                            else
                                                anade(esto);
                                        }
                                        function anade(esto) {

                                            if (esto.value.length > otro) {
                                                if (esto.value.length === 2) {
                                                    esto.value += "/";
                                                }
                                            }
                                            if (esto.value.length > otro) {
                                                if (esto.value.length === 5) {
                                                    esto.value += "/";
                                                }
                                            }
                                            if (esto.value.length < otro) {
                                                if (esto.value.length === 2 || esto.value.length === 5) {
                                                    esto.value = esto.value.substring(0, esto.value.length - 1);
                                                }
                                            }
                                            otro = esto.value.length;
                                        }


                                        function AvisaID(id) {
                                            //alert(id);
                                        }
                                        var formatNumber = {
                                            separador: ",", // separador para los miles
                                            sepDecimal: '.', // separador para los decimales
                                            formatear: function(num) {
                                                num += '';
                                                var splitStr = num.split('.');
                                                var splitLeft = splitStr[0];
                                                var splitRight = splitStr.length > 1 ? this.sepDecimal + splitStr[1] : '';
                                                var regx = /(\d+)(\d{3})/;
                                                while (regx.test(splitLeft)) {
                                                    splitLeft = splitLeft.replace(regx, '$1' + this.separador + '$2');
                                                }
                                                return this.simbol + splitLeft + splitRight;
                                            },
                                            new : function(num, simbol) {
                                                this.simbol = simbol || '';
                                                return this.formatear(num);
                                            }
                                        };


                                        $(function() {
                                            $("#cad").datepicker();
                                            $("#cad").datepicker('option', {dateFormat: 'dd/mm/yy'});
                                        });
                                        function totalPiezas() {
                                            var TarimasC = document.getElementById('TarimasC').value;
                                            var CajasxTC = document.getElementById('CajasxTC').value;
                                            var PzsxCC = document.getElementById('PzsxCC').value;
                                            var TarimasI = document.getElementById('TarimasI').value;
                                            var CajasxTI = document.getElementById('CajasxTI').value;
                                            var Resto = document.getElementById('Resto').value;
                                            if (TarimasC === "") {
                                                TarimasC = 0;
                                            }
                                            if (CajasxTC === "") {
                                                CajasxTC = 0;
                                            }
                                            if (PzsxCC === "") {
                                                PzsxCC = 0;
                                            }
                                            if (TarimasI === "") {
                                                TarimasI = 0;
                                            }
                                            if (CajasxTI === "") {
                                                CajasxTI = 0;
                                            }
                                            if (Resto === "") {
                                                Resto = 0;
                                            }
                                            var totalTarimas = parseInt(TarimasC) + parseInt(TarimasI);
                                            document.getElementById('Tarimas').value = formatNumber.new(totalTarimas);
                                            var totalCajas = parseInt(CajasxTC) * parseInt(TarimasC) + parseInt(CajasxTI);
                                            document.getElementById('Cajas').value = formatNumber.new(totalCajas);
                                            var totalPiezas = parseInt(PzsxCC) * parseInt(totalCajas);
                                            document.getElementById('Piezas').value = formatNumber.new(totalPiezas + parseInt(Resto));
                                        }

                                        function validaCompra() {

                                            var folioRemi = document.getElementById('folioRemi').value;
                                            if (folioRemi === "") {
                                                alert("Falta Folio de Remisión");
                                                document.getElementById('codbar').focus();
                                                return false;
                                            }

                                            var codBar = document.getElementById('codbar').value;
                                            if (codBar === "") {
                                                alert("Falta Código de Barras");
                                                document.getElementById('codbar').focus();
                                                return false;
                                            }

                                            var lot = document.getElementById('lot').value;
                                            if (lot === "" || lot === "-") {
                                                alert("Falta Lote");
                                                document.getElementById('lot').focus();
                                                return false;
                                            }

                                            var marca = document.getElementById('list_marca').value;
                                            if (marca === "" || marca === "-") {
                                                alert("Falta Marca");
                                                document.getElementById('list_marca').focus();
                                                return false;
                                            }

                                            var cad = document.getElementById('cad').value;
                                            if (cad === "") {
                                                alert("Falta Caducidad");
                                                document.getElementById('lot').focus();
                                                return false;
                                            } else {
                                                var dtFechaActual = new Date();
                                                var sumarDias = parseInt(276);
                                                dtFechaActual.setDate(dtFechaActual.getDate() + sumarDias);
                                                var fechaSpl = cad.split("/");
                                                var Caducidad = fechaSpl[2] + "-" + fechaSpl[1] + "-" + fechaSpl[0];
                                                /*alert(Caducidad);*/

                                                if (Date.parse(dtFechaActual) > Date.parse(Caducidad)) {
                                                    alert("La fecha de caducidad no puede ser menor a 9 meses próximos");
                                                    document.getElementById('cad').focus();
                                                    return false;
                                                }
                                            }

                                            var Piezas = document.getElementById('Piezas').value;
                                            if (Piezas === "" || Piezas === "0") {
                                                document.getElementById('Piezas').focus();
                                                alert("Favor de llenar todos los datos");
                                                return false;
                                            }
                                        }


                                        function tabular(e, obj)
                                        {
                                            tecla = (document.all) ? e.keyCode : e.which;
                                            if (tecla != 13)
                                                return;
                                            frm = obj.form;
                                            for (i = 0; i < frm.elements.length; i++)
                                                if (frm.elements[i] == obj)
                                                {
                                                    if (i == frm.elements.length - 1)
                                                        i = -1;
                                                    break
                                                }
                                            /*ACA ESTA EL CAMBIO*/
                                            if (frm.elements[i + 1].disabled == true)
                                                tabular(e, frm.elements[i + 1]);
                                            else
                                                frm.elements[i + 1].focus();
                                            return false;
                                        }


    </script>

</html>
