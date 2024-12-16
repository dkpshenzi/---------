const API_BASE = window.location.origin;

// 加载表格数据
$("#load-table").click(async function(){
    const tableName = $("#table-select").val();
    if(!tableName){
        alert("请选择表名");
        return;
    }

    // 请求数据
    const response = await fetch(`${API_BASE}/api/get_data`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            table: tableName.trim()
        }),
    });

    const result = await response.json();
    if (response.status != 200){
        alert(`错误：${result.message}`);
        return;
    }
    // 初始化DataTable
    if($.fn.DataTable.isDataTable("#data-table")){
        const table = $("#data-table").DataTable();
        table.clear(); // 清空现有数据
        table.destroy(); // 销毁实例
        $("#table-header").empty(); // 清空表头
        $("#data-table tbody").empty(); // 清空表体
    }

    // 这里需要判断是否是可以编辑的表格：
    const response1 = await fetch(`${API_BASE}/api/is_editable`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            table: tableName.trim(),
        }),
    });
    const result1 = await response1.json();
    const isEditable = result1.isEditable;

    console.log(isEditable);
    // 动态生成表头
    $("#table-header").empty();
    $("#data-table tbody").empty();
    result.columns.forEach(col=>{
        $("#table-header").append(`<th>${col}</th>`)
    });
    // 添加操作列的表头
    if (isEditable){
        $("#table-header").append(`<th>操作</th>`);
        $("#add-btn").show();
    }else{
        $("#add-btn").hide();
    };

    // 动态生成数据行
    if (result.data && Array.isArray(result.data)) {
        if (!isEditable){
            const tableBody = result.data.map(row => {
                const rowHtml = result.columns.map(col => `<td>${row[col] || ""}</td>`).join("");
                return `
                    <tr>
                        ${rowHtml}
                    </tr>
                `;
            }).join("");
            $("#data-table tbody").html(tableBody);
        }else{
            const tableBody = result.data.map(row => {
                const rowHtml = result.columns.map(col => `<td>${row[col] || ""}</td>`).join("");
                return `
                    <tr>
                        ${rowHtml}
                        <td>
                            <button class="edit-btn" data-row='${JSON.stringify(row)}'>编辑</button>
                            <button class="delete-btn" data-row='${row[result.columns[0]]}'>删除</button>
                        </td>
                    </tr>
                `;
            }).join("");
            $("#data-table tbody").html(tableBody);
        };
    } else {
        $("#data-table tbody").html("<tr><td colspan='100%'>No data available!!!</td></tr>");
    };

    // 初始化DataTable
    $("#data-table").DataTable({
        destroy: true, // 确保可以重复初始化
        searching: true, // 搜索功能
        paging: true, // 分页功能
        ordering: true, // 排序功能
        autoWidth: false, // 防止列宽问题
        pageLength: 50, // 每页显示的行数
        dom:"Bfrtip", // 添加到处按钮的布局
        buttons: [
            {
                extend:"excelHtml5",
                text:"导出Excel",
                className:"btn btn-success",
                filename : function(){
                    const tableName = $("#table-select").val();
                    const formattedDate = getFormattedDate();
                    return `${tableName}_${formattedDate}`;
                },
                exportOptions:{
                    columns: function (idx, data, node) {
                        const header = $($("#data-table").DataTable().column(idx).header()).text().trim();
                        return header !== "操作"; // 排除 "操作" 列
                    },  // 默认到处所有可见列
                    header: true, // 默认导出表头
                    format: {
                        header: function (data, columnIdx) {
                            // 获取当前列的 header 元素
                            const header = $($("#data-table").DataTable().column(columnIdx).header());
                            const label = header.find('label').text(); // 获取 label 内容
                            return label || data; // 如果存在 label，返回 label，否则返回原始 header
                        }
                    }
                },
            }
        ],
        initComplete:function(){
            const table = this.api();

            // 为每列生成筛选器
            table.columns().every(function(){
                const column = this;
                const header = $(column.header());
                const columnTitle = header.text().trim(); // 获取列的标题
                // 判断是否是“操作”列，如果是，则跳过
                if (columnTitle === '操作') {
                    console.log("跳过操作列");
                    return;
                }
                // 创建下拉框
                const label = $(`<label>${columnTitle}</label><br>`)
                    .appendTo($(header).empty());
                const select = $(`<select id="table-child-select"><option value="">所有</option></select>`)
                    .appendTo($(header))
                    .on("change",function(){
                        const val = $.fn.dataTable.util.escapeRegex($(this).val());
                        column.search(val ? `^${val}$` : "",true,false).draw();
                    });
                // 填充下拉框选项
                column.data().unique().sort().each(function (d,j){
                    select.append(`<option value="${d}">${d}</option>`)
                });
            })
        }
    });
});

// 获取日期
const getFormattedDate = () => {
    const currentDate = new Date();
    return new Intl.DateTimeFormat("zh-CN", { year: "numeric", month: "2-digit", day: "2-digit" })
        .format(currentDate)
        .replace(/\//g, "-"); // 将斜杠替换为短横线
};

// 动态更新下拉框数据
async function loadViewNames(){
    try{
        // 发起请求，返回的是表名的列表
        let response = await fetch(`${API_BASE}/api/get_views`);
        let tableNames = await response.json();
        // 获取下拉框元素
        let selectElement = document.getElementById("table-select");
        // 清空现有的选项
        selectElement.innerHTML = "";
        // 创建下拉框
        await tableNames.forEach(function(name){
            let option = document.createElement("option");
            option.value = name;
            option.textContent = name;
            selectElement.appendChild(option);
        })
    }catch(error){
        console.error(`无法加载表数据 ${error}`);
    }
    return;
}

// 监听下拉框的变化，更新表格数据
$("#table-select").change(function(){
    $("#load-table").click();
});

// 监听创建视图的点击按钮
$("create-view").click(async function(){
    const sqlContent = $("view-create").val();
    if(!sqlContent){
        alert("请输入视图创建语句");
        return;
    }
    // 请求数据
    const response = await fetch(`${API_BASE}/api/create_view`,{
        method:"POSE",
        headers:{
            "Content-Type":"application/json"
        },
        body:JSON.stringify({
            sql:sqlContent.trim()
        })
    });
    const result = await response.json();
    if(response.status != 200){
        alert(`错误：${result.message}`);
        return;
    }
})

// 当页面加载时，就调用函数动态更新下拉框
window.onload = async function(){
    await loadViewNames();
    $("#load-table").click();
}