<%-- 
    Document   : reporteASF
    Created on : 01-abr-2015, 12:01:13
    Author     : amerikillo
--%>

<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>
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
    DecimalFormat formatter = new DecimalFormat("#######");
    DecimalFormat formatter2 = new DecimalFormat("#######.##");
    DecimalFormatSymbols custom = new DecimalFormatSymbols();
    custom.setDecimalSeparator(',');
    formatter.setDecimalFormatSymbols(custom);
    HttpSession sesion = request.getSession();
    String usua = "ISEM";
    ConectionDB con = new ConectionDB();

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- Estilos CSS -->
        <link href="../css/bootstrap.css" rel="stylesheet">
        <link href="../css/datepicker3.css" rel="stylesheet">
        <link rel="stylesheet" href="../css/cupertino/jquery-ui-1.10.3.custom.css" />
        <link href="../css/navbar-fixed-top.css" rel="stylesheet">
        <!---->
        <title>SIALSS</title>
    </head>
    <body class="container">
        <h1>SIALSS</h1>
        <h4>SISTEMA INTEGRAL DE ADMINISTRACIÓN Y LOGÍSTICA PARA LOS SERVICIOS DE SALUD</h4>
        <hr/>

        <!--div class="text-muted">
            Esta información se obtiene al momento de la consulta
        </div>
        <div class="text-muted">
            CPM: El Promedio Mensual de lo entregado (Remisiones - Devoluciones)
        </div>
        <div class="text-muted">
            CPCM: Consumo Promedio Calculado Mensual determinado por el Instituto para la compra del 2014
        </div>
        <div class="text-muted">
            ASF: Estimada en meses (Existencias entre CPM)
        </div-->
        <div class="panel panel-primary">
            <div class="panel-heading">
                Autosuficiencia
                <a href="gnrReporteASF.jsp" class="btn btn-primary" target="_blank"><span class="glyphicon glyphicon-download"></span></a>
            </div>
            <div class="panel-body">
                <table class="table table-bordered table-condensed table-striped" id="datosProv">
                    <thead>
                        <tr>
                            <td></td> 
                            <td>Catálogo</td>
                            <td>Clave</td>
                            <td>Descripción</td>
                            <td>Existencias a la fecha </td>
                            <td>Piezas entregadas a la fecha</td>
                            <td>CPM Sur</td>
                            <td>Meses de Inv (ASF) Sur</td>
                            <td>Piezas Solicitadas a la fecha</td>
                            <td>CPM Sol</td>
                            <td>Meses de Inv (ASF) Sol</td>
                            <td></td>
                        </tr>
                    </thead>
                    <tbody>
                        <%                            int TotalClaves = 1, contado = 1;
                            try {
                                con.conectar();
                                ResultSet rset = con.consulta("select F_ClaPro from tb_medica where (F_ClaPro in (select F_ClaPro from tb_cat2014)) or (F_ClaPro in (select F_ClaPro from tb_cat2015))");
                                while (rset.next()) {

                                    String F_DesPro = "", catalogo = "2014";
                                    double totalClave = 0, remisionadoClave = 0, CPM = 0, CPCM2014 = 0, invMen2014 = 0, solClave = 0, CPMSol = 0, NIMSol = 0;
                                    ResultSet rset2 = con.consulta("select F_ClaPro from tb_cat2015 where F_ClaPro = '" + rset.getString("F_ClaPro") + "'");
                                    while (rset2.next()) {
                                        catalogo = "2015";
                                    }

                                    rset2 = con.consulta("select t1.F_ClaPro from tb_cat2015 t1, tb_cat2014 t2 where t1.F_ClaPro = t2.F_ClaPro and t1.F_ClaPro = '" + rset.getString("F_ClaPro") + "'");
                                    while (rset2.next()) {
                                        catalogo = "2014/2015";
                                    }

                                    rset2 = con.consulta("select F_DesPro from tb_medica where F_ClaPro = '" + rset.getString("F_ClaPro") + "' ");

                                    while (rset2.next()) {
                                        F_DesPro = rset2.getString("F_DesPro");
                                    }

                                    int difd = 0, difd2 = 0, meses = 0;
                                    rset2 = con.consulta("select datediff( now(), F_FecCarg ) as dias from tb_unireq where F_ClaPro='" + rset.getString("F_ClaPro") + "' LIMIT 1;");
                                    while (rset2.next()) {
                                        difd2 = rset2.getInt(1);
                                    }

                                    rset2 = con.consulta("select datediff( now(), F_FecMov ) as dias from tb_movinv where F_ProMov='" + rset.getString("F_ClaPro") + "' LIMIT 1;");
                                    while (rset2.next()) {
                                        difd = rset2.getInt(1);
                                    }
                                    if (difd2 > difd) {
                                        difd = difd2;
                                    }
                                    rset2 = con.consulta("select TIMESTAMPDIFF(month, now(), '2016-02-01' ) as meses;");
                                    while (rset2.next()) {
                                        meses = rset2.getInt(1);
                                    }

                                    Double NIM = 0.0;

                                    rset2 = con.consulta("select (F_ExiLot) as F_ExiLot from tb_lote where F_ClaPro = '" + rset.getString("F_ClaPro") + "' and F_ExiLot!=0 union all select -F_Cant from clavefact where F_ClaPro = '" + rset.getString("F_ClaPro") + "' and F_StsFact<5");
                                    while (rset2.next()) {
                                        totalClave += rset2.getInt(1);
                                    }

                                    rset2 = con.consulta("select SUM(F_CantSur) as F_CantSur from tb_factura where F_ClaPro = '" + rset.getString("F_ClaPro") + "' and F_StsFact='A'  ");
                                    while (rset2.next()) {
                                        remisionadoClave = rset2.getDouble("F_CantSur");
                                    }
                                    rset2 = con.consulta("select F_ClaPro, (F_PiezasReq) from tb_unireq where F_Status=1 and F_ClaPro = '" + rset.getString("F_ClaPro") + "'   GROUP BY F_FecCarg, F_ClaPro, F_ClaUni ");
                                    while (rset2.next()) {
                                        solClave = solClave + rset2.getDouble(2);
                                    }
                                    if (solClave < remisionadoClave) {
                                        solClave = remisionadoClave;
                                    }
                                    if (remisionadoClave > 0) {
                                        CPM = (remisionadoClave / difd) * 30;
                                        NIM = (double) totalClave / CPM;
                                    }

                                    if (solClave > 0) {
                                        CPMSol = (solClave / difd) * 30;
                                        NIMSol = (double) totalClave / CPMSol;
                                    }


                        %>
                        <tr>
                            <td><%=TotalClaves%></td>
                            <td><%=catalogo%></td>
                            <td title="<%=F_DesPro%>"><strong><%=rset.getString("F_ClaPro")%></strong></td>
                            <td><%=F_DesPro%></td>
                            <td class="text-right"><%=formatter.format(totalClave)%></td>
                            <td class="text-right <%                                if (NIM > meses) {
                                    out.println("success");
                                } else if (NIM < 1.6 && NIM > 0) {
                                    out.println("warning");
                                } else if (NIM == 0) {
                                    out.println("danger");
                                }
                                %>"><%=formatter.format(remisionadoClave)%></td>
                            <td class="text-right <%                                if (NIM > meses) {
                                    out.println("success");
                                } else if (NIM < 1.6 && NIM > 0) {
                                    out.println("warning");
                                } else if (NIM == 0) {
                                    out.println("danger");
                                }
                                %>"><%=formatter.format(CPM)%></td>
                            <td class="text-right <%                                if (NIM > meses) {
                                    out.println("success");
                                } else if (NIM < 1.6 && NIM > 0) {
                                    out.println("warning");
                                } else if (NIM == 0) {
                                    out.println("danger");
                                }
                                %>"><%=formatter2.format(NIM)%></td>
                            <td class="text-right <%                                if (NIMSol > meses) {
                                    out.println("success");
                                } else if (NIMSol < 1.6 && NIMSol > 0) {
                                    out.println("warning");
                                } else if (NIMSol == 0) {
                                    out.println("danger");
                                }
                                %>"><%=formatter.format(solClave)%></td>
                            <td class="text-right <%                                if (NIMSol > meses) {
                                    out.println("success");
                                } else if (NIMSol < 1.6 && NIMSol > 0) {
                                    out.println("warning");
                                } else if (NIMSol == 0) {
                                    out.println("danger");
                                }
                                %>"><%=formatter.format(CPMSol)%></td>
                            <td class="text-right <%                                if (NIMSol > meses) {
                                    out.println("success");
                                } else if (NIMSol < 1.6 && NIMSol > 0) {
                                    out.println("warning");
                                } else if (NIMSol == 0) {
                                    out.println("danger");
                                }
                                %>"><%=formatter2.format(NIMSol)%></td>
                            <td>
                                <%
                                    if (NIM > meses) {
                                        out.println("Sobre abasto");
                                    } else if (NIM < 1.6 && NIM > 0) {
                                        out.println("Prox. a agotar");
                                    } else if (totalClave == 0) {
                                        out.println("Agotada");
                                    } else if (totalClave > 0 && NIM == 0) {
                                        out.println("Pendiente por Entregar");
                                    } else if (totalClave == 0 && NIM == 0) {
                                        out.println("En cero");
                                    }
                                %>
                            </td>
                        </tr>
                        <%
                                    TotalClaves++;
                                }

                                con.cierraConexion();
                            } catch (Exception e) {
                                out.println(e.getMessage());
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>


        <!-- 
        ================================================== -->
        <!-- Se coloca al final del documento para que cargue mas rapido -->
        <!-- Se debe de seguir ese orden al momento de llamar los JS -->
        <script src="../js/jquery-1.9.1.js"></script>
        <script src="../js/bootstrap.js"></script>
        <script src="../js/jquery-ui-1.10.3.custom.js"></script>
        <script src="../js/jquery.dataTables.js"></script>
        <script src="../js/dataTables.bootstrap.js"></script>
        <script src="../js/bootstrap-datepicker.js"></script>
        <script>
            $(document).ready(function() {
                $('#datosProv').dataTable();
            });
        </script>
    </body>
</html>
