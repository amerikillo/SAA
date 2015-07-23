/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ISEM;

import Correo.CorreoConfirmaRemision;
import conn.ConectionDB;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

/**
 *
 * @author Americo
 */
public class CompraAutomatica extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     *
     *
     * Funciones para la compra automática
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession sesion = request.getSession(true);
        ConectionDB con = new ConectionDB();
        NuevoISEM nuevo = new NuevoISEM();
        JSONObject json = new JSONObject();
        JSONArray jsona = new JSONArray();
        CorreoConfirmaRemision correoConfirma = new CorreoConfirmaRemision();

        DateFormat df2 = new SimpleDateFormat("yyyy-MM-dd");
        DateFormat df3 = new SimpleDateFormat("dd/MM/yyyy");

        PrintWriter out = response.getWriter();
        try {
            String mensaje = "";
            /**
             * Para obtener el folio de remisión y depositarlo en un JSON Se
             * utiliza en el JSP de compraAuto2.jsp Nos dice si esa remisión con
             * ese folio ya se ha utilizado.
             */
            if (request.getParameter("accion").equals("buscarFolio")) {
                con.conectar();
                ResultSet rset = con.consulta("select F_FolRemi from tb_compra where F_FolRemi='" + request.getParameter("F_FolRemi") + "' and F_OrdCom='" + request.getParameter("F_OrdCom") + "' limit 1");
                while (rset.next()) {
                    json.put("mensaje", "FolioCapturado");
                    jsona.add(json);
                    json = new JSONObject();
                }
                out.println(jsona);
                System.out.println(jsona);
            }
            /**
             * Del botón 'Clave' nos almacena en sesion el valor de la clave
             * incluyendo el número de compra y el folio de remisión
             */
            if (request.getParameter("accion").equals("seleccionaClave")) {
                String folio = request.getParameter("folio");
                String folioRemi = request.getParameter("folioRemi");
                String seleccionaClave = request.getParameter("selectClave");
                sesion.setAttribute("NoCompra", request.getParameter("folio"));
                sesion.setAttribute("folioRemi", folioRemi);
                sesion.setAttribute("Lote", "");
                sesion.setAttribute("Cadu", "");
                sesion.setAttribute("CodBar", "");
                sesion.setAttribute("claveSeleccionada", seleccionaClave);
                response.sendRedirect("compraAuto2.jsp");
            }

            /**
             * Del botón 'CB' nos almacena en sesion el valor de la clave
             * incluyendo el número de compra y el folio de remisión
             */
            if (request.getParameter("accion").equals("CodigoBarras")) {
                try {
                    String posCla = sesion.getAttribute("posClave").toString();
                    String folio = request.getParameter("folio");
                    String folioRemi = request.getParameter("folioRemi");
                    String CodBar = request.getParameter("codbar");
                    String lote = request.getParameter("lot").toUpperCase();
                    String cadu = request.getParameter("cad");
                    String seleccionaClave = request.getParameter("ClaPro");
                    System.out.println(seleccionaClave + "----6666666");
                    sesion.setAttribute("NoCompra", request.getParameter("folio"));
                    sesion.setAttribute("folioRemi", folioRemi);
                    sesion.setAttribute("CodBar", CodBar);
                    sesion.setAttribute("Lote", "");
                    sesion.setAttribute("Cadu", "");
                    sesion.setAttribute("claveSeleccionada", seleccionaClave);
                    response.sendRedirect("compraAuto2.jsp");
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
            }
            /**
             * Método para generar el siguiente código de barras para insumos
             * que no cuentan con código (Mat Cur)
             */
            if (request.getParameter("accion").equals("GeneraCodigo")) {
                String CodBar = "";
                try {
                    con.conectar();
                    ResultSet rset = con.consulta("SELECT MAX(F_IdCb) AS F_IdCb FROM tb_gencb");
                    while (rset.next()) {
                        CodBar = rset.getString("F_IdCb");
                    }
                    System.out.println(CodBar);
                    Long CB = Long.parseLong(CodBar) + 1;
                    con.insertar("insert into tb_gencb values('" + CB + "','GNKL')");

                    con.cierraConexion();
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
                /**
                 * Se almacenan datos en variables de sesión
                 */
                try {
                    String posCla = sesion.getAttribute("posClave").toString();
                    String folio = request.getParameter("folio");
                    String folioRemi = request.getParameter("folioRemi");
                    String lote = request.getParameter("lot").toUpperCase();
                    String cadu = request.getParameter("cad");
                    sesion.setAttribute("NoCompra", request.getParameter("folio"));
                    sesion.setAttribute("folioRemi", folioRemi);
                    sesion.setAttribute("CodBar", CodBar);
                    sesion.setAttribute("Lote", "");
                    sesion.setAttribute("Cadu", "");
                    response.sendRedirect("compraAuto2.jsp");
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
            }
            /**
             * Método que se utilizaba cuando estaba paginado el proceso, ya no
             * se usan
             */
            if (request.getParameter("accion").equals("verFolio")) {
                try {
                    String posCla = sesion.getAttribute("posClave").toString();
                    String folio = request.getParameter("folio");
                    String folioRemi = request.getParameter("folioRemi");
                    String CodBar = request.getParameter("codbar");
                    String lote = request.getParameter("lot").toUpperCase();
                    String cadu = request.getParameter("cad");
                    sesion.setAttribute("NoCompra", request.getParameter("folio"));
                    sesion.setAttribute("folioRemi", folioRemi);
                    sesion.setAttribute("CodBar", CodBar);
                    sesion.setAttribute("Lote", lote);
                    sesion.setAttribute("Cadu", cadu);
                    response.sendRedirect("compraAuto2.jsp");
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
            }
            /**
             * Para refrescar la pagina
             */
            if (request.getParameter("accion").equals("refresh")) {
                try {
                    String posCla = sesion.getAttribute("posClave").toString();
                    String folio = request.getParameter("folio");
                    String folioRemi = request.getParameter("folioRemi");
                    String CodBar = request.getParameter("codbar");
                    String lote = request.getParameter("lot").toUpperCase();
                    String cadu = request.getParameter("cad");
                    sesion.setAttribute("NoCompra", request.getParameter("folio"));
                    sesion.setAttribute("folioRemi", folioRemi);
                    sesion.setAttribute("CodBar", CodBar);
                    sesion.setAttribute("Lote", lote);
                    sesion.setAttribute("Cadu", cadu);
                    response.sendRedirect("compraAuto2.jsp");
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
            }
            /**
             * Metodo para avanzar el paginado, (YA NO SE USA)
             */
            if (request.getParameter("accion").equals("siguiente")) {
                try {
                    String posCla = sesion.getAttribute("posClave").toString();
                    String folio = request.getParameter("folio");
                    String folioRemi = request.getParameter("folioRemi");
                    int posClave = Integer.parseInt(posCla);
                    posClave++;
                    System.out.println("/////" + posClave);
                    sesion.setAttribute("posClave", posClave);
                    sesion.setAttribute("NoCompra", request.getParameter("folio"));
                    sesion.setAttribute("folioRemi", folioRemi);
                    sesion.setAttribute("CodBar", "");
                    sesion.setAttribute("Lote", "");
                    sesion.setAttribute("Cadu", "");
                    response.sendRedirect("compraAuto2.jsp");
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
            } 
            /**
             * Metodo para regresar el paginado, (YA NO SE USA)
             */
            if (request.getParameter("accion").equals("anterior")) {
                try {
                    String posCla = sesion.getAttribute("posClave").toString();
                    String folio = request.getParameter("folio");
                    String folioRemi = request.getParameter("folioRemi");
                    int posClave = Integer.parseInt(posCla);
                    posClave--;
                    System.out.println("/////" + posClave);
                    sesion.setAttribute("posClave", posClave);
                    sesion.setAttribute("NoCompra", request.getParameter("folio"));
                    sesion.setAttribute("folioRemi", folioRemi);
                    sesion.setAttribute("CodBar", "");
                    sesion.setAttribute("Lote", "");
                    sesion.setAttribute("Cadu", "");
                    response.sendRedirect("compraAuto2.jsp");
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }

            }
             /**
             * Metodo para guardar el lote que se está ingresando
             */
            if (request.getParameter("accion").equals("guardarLote")) {

                try {
                    String posCla = sesion.getAttribute("posClave").toString();
                    String folio = request.getParameter("folio");
                    String folioRemi = request.getParameter("folioRemi");
                    sesion.setAttribute("NoCompra", request.getParameter("folio"));
                    sesion.setAttribute("folioRemi", "");
                    sesion.setAttribute("CodBar", "");
                    sesion.setAttribute("Lote", "");
                    sesion.setAttribute("Cadu", "");
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
                con.conectar();
                Calendar c1 = GregorianCalendar.getInstance();
                String Tipo = "";
                double Costo = 0.0, IVA = 0.0, Monto = 0.0, IVAPro = 0.0, MontoIva = 0.0;
                String lote = request.getParameter("lot").toUpperCase();
                String Clave = request.getParameter("ClaPro");
                String cadu = df2.format(df3.parse(request.getParameter("cad")));
                c1.setTime(df3.parse(request.getParameter("cad")));

                /**
                 * Para obtener costo y generar la fecha de fabricación
                 * 
                 * Tipo: 2504 Medicamento sin IVA tres años atras para fecha de fabricación
                 * Tipo: 2505 Mat Cur con IVA5 años para atras para fecha de fabricación
                 */
                ResultSet rset_medica = con.consulta("SELECT F_TipMed,F_Costo FROM tb_medica WHERE F_ClaPro='" + Clave + "'");
                while (rset_medica.next()) {
                    Tipo = rset_medica.getString("F_TipMed");
                    Costo = Double.parseDouble(rset_medica.getString("F_Costo"));
                    if (Tipo.equals("2504")) {
                        c1.add(Calendar.YEAR, -3);
                        IVA = 0.0;
                    } else {
                        IVA = 0.16;
                        c1.add(Calendar.YEAR, -5);
                    }
                }
                
                /**
                 * Si la fecha de fabricación es mayor que la actual se resta a la actual 1 año
                 */
                Calendar FecAct = GregorianCalendar.getInstance();
                FecAct.setTime(new Date());
                while (c1.after(FecAct)) {
                    c1.add(Calendar.YEAR, -1);
                }
                String fecFab = (df2.format(c1.getTime()));
                String CodBar = request.getParameter("codbar");
                String Tarimas = request.getParameter("Tarimas");
                String claPro = request.getParameter("claPro");
                String Marca = request.getParameter("list_marca");
                byte[] a = request.getParameter("Obser").getBytes("ISO-8859-1");
                String F_Obser = (new String(a, "UTF-8")).toUpperCase();

                String TCajas = request.getParameter("TCajas");
                TCajas = TCajas.replace(",", "");

                /**
                 * 
                 * Obtención de las cantidades en cuanto cajas piezas y restos
                 * se quitan las 'comas' ya que se envian en el parametro
                 */
                if (Tarimas.equals("")) {
                    Tarimas = "0";
                }
                Tarimas = Tarimas.replace(",", "");
                String Cajas = request.getParameter("Cajas");
                if (Cajas.equals("")) {
                    Cajas = "0";
                }
                Cajas = Cajas.replace(",", "");
                String Piezas = request.getParameter("Piezas");
                if (Piezas.equals("")) {
                    Piezas = "0";
                }
                Piezas = Piezas.replace(",", "");
                String TarimasI = request.getParameter("TarimasI");
                if (TarimasI.equals("")) {
                    TarimasI = "0";
                }
                TarimasI = TarimasI.replace(",", "");
                String CajasxTI = request.getParameter("CajasxTI");
                if (CajasxTI.equals("")) {
                    CajasxTI = "0";
                }
                CajasxTI = CajasxTI.replace(",", "");
                String Resto = request.getParameter("Resto");
                if (Resto.equals("")) {
                    Resto = "0";
                }
                if (Clave.equals("4186")) {
                    Costo = Costo / 30;
                }
                Resto = Resto.replace(",", "");
                
                /**
                 * Se calculan costos
                 */
                IVAPro = (Double.parseDouble(Piezas) * Costo) * IVA;
                Monto = Double.parseDouble(Piezas) * Costo;
                MontoIva = Monto + IVAPro;
                
                /**
                 * Inserción en la tabla temporal 
                 */
                con.insertar("insert into tb_compratemp values(0,CURDATE(),'" + Clave + "','" + lote + "','" + cadu + "','" + fecFab + "','" + Marca + "','" + claPro + "','" + CodBar + "','" + Tarimas + "','" + TCajas + "','" + Piezas + "','" + TarimasI + "','" + CajasxTI + "','" + Resto + "','" + Costo + "','" + IVAPro + "','" + MontoIva + "','" + F_Obser + "','" + request.getParameter("folioRemi") + "','" + request.getParameter("folio") + "','" + claPro + "','" + sesion.getAttribute("nombre") + "','1')"
                );
                /**
                 * Inserción en la tabla de registros de compras, esto para llevar un historico completo aunque se cancelen
                 */
                con.insertar("insert into tb_compraregistro values(0,CURDATE(),'" + Clave + "','" + lote + "','" + cadu + "','" + fecFab + "','" + Marca + "','" + claPro + "','" + CodBar + "','" + Tarimas + "','" + TCajas + "','" + Piezas + "','" + TarimasI + "','" + CajasxTI + "','" + Resto + "','" + Costo + "','" + IVAPro + "','" + MontoIva + "','" + F_Obser + "','" + request.getParameter("folioRemi") + "','" + request.getParameter("folio") + "','" + claPro + "','" + sesion.getAttribute("nombre") + "')"
                );
                try {
                    con.insertar("insert into tb_pzcaja values (0,'" + claPro + "','" + Marca + "','" + request.getParameter("PzsxCC") + "','" + Clave + "')");
                } catch (Exception e) {
                }
                /**
                 * Inserción en la tabla de tb_cb para tener todo el registro de insutmos: clave, lote, caducidad, fec fabricacion, marca referentes a ese lote
                 */
                con.insertar("insert into tb_cb values(0,'" + CodBar + "','" + Clave + "','" + lote + "','" + cadu + "','" + fecFab + "', '" + Marca + "')");
                //con.insertar("update tb_pedidoisem set F_Recibido = '1' where F_Clave = '" + Clave + "' and  ");

                con.cierraConexion();
                response.sendRedirect("compraAuto2.jsp");
            }
            
            /**
             * Se utilizaba para inserta en la compra manual, ya no se utiliza porque se termina validando por parte de auditorías
             */
            if (request.getParameter("accion").equals("confirmar")) {
                con.conectar();
                try {
                    ResultSet rset = con.consulta("select * from tb_pedidoisem where F_NoCompra = '" + request.getParameter("folio") + "' and F_Recibido = '0'");
                    while (rset.next()) {
                        Calendar c1 = GregorianCalendar.getInstance();
                        String Tipo = "";
                        double Costo = 0.0, IVA = 0.0, Monto = 0.0, IVAPro = 0.0, MontoIva = 0.0;
                        String lote = request.getParameter("lot_" + rset.getString("F_IdIsem"));
                        String Clave = rset.getString("F_Clave");
                        String cadu = df2.format(df3.parse(request.getParameter("cad_" + rset.getString("F_IdIsem"))));
                        c1.setTime(df3.parse(request.getParameter("cad_" + rset.getString("F_IdIsem"))));

                        ResultSet rset_medica = con.consulta("SELECT F_TipMed,F_Costo FROM tb_medica WHERE F_ClaPro='" + Clave + "'");
                        while (rset_medica.next()) {
                            Tipo = rset_medica.getString("F_TipMed");
                            Costo = Double.parseDouble(rset_medica.getString("F_Costo"));
                            if (Tipo.equals("2504")) {
                                c1.add(Calendar.YEAR, -3);
                                IVA = 0.0;
                            } else {
                                c1.add(Calendar.YEAR, -5);
                                IVA = 0.16;
                            }
                        }

                        Calendar FecAct = GregorianCalendar.getInstance();
                        FecAct.setTime(new Date());
                        while (c1.after(FecAct)) {
                            c1.add(Calendar.YEAR, -1);
                        }
                        String fecFab = (df2.format(c1.getTime()));
                        String CodBar = request.getParameter("codbar_" + rset.getString("F_IdIsem"));
                        String Tarimas = request.getParameter("Tarimas_" + rset.getString("F_IdIsem"));
                        String Marca = request.getParameter("list_marca");
                        byte[] a = request.getParameter("Obser_" + rset.getString("F_IdIsem")).getBytes("ISO-8859-1");
                        String F_Obser = (new String(a, "UTF-8")).toUpperCase();

                        if (Tarimas.equals("")) {
                            Tarimas = "0";
                        }
                        String Cajas = request.getParameter("Cajas_" + rset.getString("F_IdIsem"));
                        if (Cajas.equals("")) {
                            Cajas = "0";
                        }
                        Cajas = Cajas.replace(",", "");
                        String Piezas = request.getParameter("Piezas_" + rset.getString("F_IdIsem"));
                        if (Piezas.equals("")) {
                            Piezas = "0";
                        }
                        Piezas = Piezas.replace(",", "");
                        String TarimasI = request.getParameter("TarimasI_" + rset.getString("F_IdIsem"));
                        if (TarimasI.equals("")) {
                            TarimasI = "0";
                        }
                        String CajasxTI = request.getParameter("CajasxTI_" + rset.getString("F_IdIsem"));
                        if (CajasxTI.equals("")) {
                            CajasxTI = "0";
                        }
                        String Resto = request.getParameter("Resto_" + rset.getString("F_IdIsem"));
                        if (Resto.equals("")) {
                            Resto = "0";
                        }
                        if (Clave.equals("4186")) {
                            Costo = Costo / 30;
                        }
                        IVAPro = (Double.parseDouble(Piezas) * Costo) * IVA;
                        Monto = Double.parseDouble(Piezas) * Costo;
                        MontoIva = Monto + IVAPro;
                        con.insertar("insert into tb_compratemp values(0,CURDATE(),'" + Clave + "','" + lote + "','" + cadu + "','" + fecFab + "','1','" + rset.getString("F_Provee") + "','" + CodBar + "','" + Tarimas + "','" + Cajas + "','" + Piezas + "','" + TarimasI + "','" + CajasxTI + "','" + Resto + "','" + Costo + "','" + IVAPro + "','" + MontoIva + "','" + F_Obser + "','" + request.getParameter("folioRemi") + "','" + request.getParameter("folio") + "','" + rset.getString("F_Provee") + "','" + sesion.getAttribute("nombre") + "','1')"
                        );
                        con.insertar("insert into tb_compraregistro values(0,CURDATE(),'" + Clave + "','" + lote + "','" + cadu + "','" + fecFab + "','1','" + rset.getString("F_Provee") + "','" + CodBar + "','" + Tarimas + "','" + Cajas + "','" + Piezas + "','" + TarimasI + "','" + CajasxTI + "','" + Resto + "','" + Costo + "','" + IVAPro + "','" + MontoIva + "','" + F_Obser + "','" + request.getParameter("folioRemi") + "','" + request.getParameter("folio") + "','" + rset.getString("F_Provee") + "','" + sesion.getAttribute("nombre") + "')"
                        );

                        System.out.println("update tb_pedidoisem set F_Recibido = '1' where F_IdIsem = '" + rset.getString("F_IdIsem") + "' ");
                        con.insertar("update tb_pedidoisem set F_Recibido = '1' where F_IdIsem = '" + rset.getString("F_IdIsem") + "' ");
                    }
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
                
                con.cierraConexion();
                int F_IndCom = nuevo.Guardar((String) sesion.getAttribute("nombre"));
                sesion.setAttribute("folioRemi", "");
                out.println("<script>window.open('reimpReporte.jsp?fol_gnkl=" + F_IndCom + "','_blank')</script>");
                out.println("<script>window.open('reimp_marbete.jsp?fol_gnkl=" + F_IndCom + "','_blank')</script>");
                //correoConfirma.enviaCorreo(F_IndCom);
                out.println("<script>window.location='Ubicaciones/Consultas.jsp'</script>");
            }
        } catch (Exception e) {
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
