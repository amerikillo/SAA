package LeeExcel;

import conn.ConectionDB;
import java.io.FileInputStream;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.Iterator;
import java.util.Vector;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 * Para insertar los requerimientos en la tabla tb_unireq
 * @author Indra Hidayatulloh
 */
public class LeeExcel {

    private Vector vectorDataExcelXLSX = new Vector();

    public boolean obtieneArchivo(String path, String file) {
        String excelXLSXFileName = path + "/exceles/" + file;
        vectorDataExcelXLSX = readDataExcelXLSX(excelXLSXFileName);
        displayDataExcelXLSX(vectorDataExcelXLSX);
        return true;
    }

    public Vector readDataExcelXLSX(String fileName) {
        Vector vectorData = new Vector();

        try {
            FileInputStream fileInputStream = new FileInputStream(fileName);

            XSSFWorkbook xssfWorkBook = new XSSFWorkbook(fileInputStream);

            // Read data at sheet 0
            XSSFSheet xssfSheet = xssfWorkBook.getSheetAt(0);

            Iterator rowIteration = xssfSheet.rowIterator();

            // Looping every row at sheet 0
            while (rowIteration.hasNext()) {
                XSSFRow xssfRow = (XSSFRow) rowIteration.next();
                Iterator cellIteration = xssfRow.cellIterator();

                Vector vectorCellEachRowData = new Vector();

                // Looping every cell in each row at sheet 0
                while (cellIteration.hasNext()) {
                    XSSFCell xssfCell = (XSSFCell) cellIteration.next();
                    vectorCellEachRowData.addElement(xssfCell);
                }

                vectorData.addElement(vectorCellEachRowData);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return vectorData;
    }

    /**
     * En este metodo es onde se arma el query y se ejecutan las inserciones
     * @param vectorData 
     */
    public void displayDataExcelXLSX(Vector vectorData) {
        // Looping every row data in vector
        ConectionDB con = new ConectionDB();
        int id_req = 0;
        String unireq = "";
        try {
            /*con.conectar();
             ResultSet rset = con.consulta("select F_IndReq from tb_indice");
             while (rset.next()) {
             id_req = rset.getInt("F_IndReq");
             }
             con.insertar("update tb_indice set F_IndReq='" + (id_req + 1) + "'");

             con.cierraConexion();*/
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        for (int i = 0; i < vectorData.size(); i++) {
            Vector vectorCellEachRowData = (Vector) vectorData.get(i);
            
            /**
             * Creación del query para hacer las inserciones
             */
            String qry = "insert into tb_unireq values (";
            // looping every cell in each row
            /**
             * Se lee cada una de las celdas, se utiliza el ciclo FOR para que recorra las celdas 0-3
             */
            for (int j = 0; j < 4; j++) {

                /**
                 * Si es 0 quiere decir que es la clave del Distribuidor
                 */
                if (j == 0) {
                    try {
                        String Clave = (vectorCellEachRowData.get(j).toString() + "");
                        try {
                            Clave = (int) Double.parseDouble(Clave) + "";
                        } catch (Exception e) {
                            Clave = Clave = (vectorCellEachRowData.get(j).toString() + "");
                        }
                        unireq = Clave;
                        qry = qry + "'" + Clave + "' , ";
                    } catch (Exception e) {
                    }
                } else if (j == 1) {
                    /**
                     * Si es 1 es el campo de clave
                     * Se da el formato que necesita la clave
                     * Si tiene .01 0 .02 al final se mantienen, en caso de que no
                     * se deja sin punto, y por default tiene que tener el siguiente formato 0000
                     */
                    System.out.println("algo");
                    try {
                        String ClaPro = ((vectorCellEachRowData.get(j).toString()) + "");
                        NumberFormat formatter = new DecimalFormat("0000.00");
                        ClaPro = formatter.format(Double.parseDouble(ClaPro));
                        String[] punto = ClaPro.split("\\.");
                        System.out.println(punto.length);
                        if (punto.length > 1) {
                            System.out.println(ClaPro + "***" + punto[0] + "////" + punto[1]);
                            if (punto[1].equals("01")) {
                                ClaPro = agrega(punto[0]) + ".01";
                            } else if (punto[1].equals("02")) {
                                ClaPro = agrega(punto[0]) + ".02";
                            } else if (punto[1].equals("00")) {
                                ClaPro = agrega(punto[0]);
                            } else {
                                ClaPro = agrega(punto[0]);
                            }
                            System.out.println(ClaPro);
                        }
                        qry = qry + "'" + agrega(ClaPro) + "' , ";
                        /*String tipMed = "";
                         con.conectar();
                         ResultSet rset2 = con.consulta("select F_TipMed from tb_medica where F_ClaPro='" + ClaPro + "'");
                         while (rset2.next()) {
                         tipMed = rset2.getString(1);
                         }
                         con.cierraConexion();
                         if (tipMed.equals("2504")) {
                         String[] dec = ClaPro.split("\\.");
                         System.out.println(dec.length);
                         System.out.println(ClaPro + "***" + dec[0] + "////" + dec[1]);
                         if (dec[1].equals("01")) {
                         qry = qry + "'" + agrega(dec[0]) + ".01" + "' , ";
                         } else {
                         qry = qry + "'" + agrega(ClaPro) + "' , ";
                         }
                         } else {
                         qry = qry + "'" + agrega(ClaPro) + "' , ";
                         }*/

                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                } else {
                    /**
                     * En caso de que no sea ninguno de los 2 anteriores quiere decir que son cajas y piezas, se insertan directamente
                     */
                    try {
                        String Clave = ((int) Double.parseDouble(vectorCellEachRowData.get(j).toString()) + "");
                        qry = qry + "'" + Clave + "' , ";
                    } catch (NumberFormatException e) {
                    }
                }
            }
            try {
                /**
                 * Se finaliza el query agregando campos de fecha status y al final se anexa de que No de Requerimiento viene para llevar una contnuidad
                 */
                qry = qry + "curdate(), 0, '0','" + unireq + "-" + (int) Double.parseDouble(vectorCellEachRowData.get(4).toString()) + "')"; // agregar campos fuera del excel
            } catch (NumberFormatException e) {
                System.out.println(e);
            }
            try {
                con.conectar();
                try {
                    /**
                     * Ejecución del query
                     */
                    con.insertar(qry);
                } catch (SQLException e) {
                    System.out.println(e.getMessage());
                }
                con.cierraConexion();
            } catch (SQLException e) {
            }
        }
    }

    
    /**
     * Metodo para agregar ceros a la clave, innecesario si se usa el formateador
     * @param clave
     * @return 
     */
    public String agrega(String clave) {
        String clave2 = "";
        if (clave.length() < 4) {

            if (!clave.substring(0, 1).equals("0")) {
                //System.out.println(clave);
                if (clave.length() == 1) {
                    clave2 = ("000" + clave);
                }
                if (clave.length() == 2) {
                    clave2 = ("00" + clave);
                }
                if (clave.length() >= 3) {
                    clave2 = ("0" + clave);
                }

            }
        } else {
            clave2 = clave;
        }
        return clave2;
    }

}
