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

// 点击编辑按钮
$(document).on("click", ".edit-btn",async function () {
    const rowData = JSON.parse($(this).attr("data-row"));

    const tableName = $("#table-select").val();
    const response = await fetch(`${API_BASE}/api/forbbiden_columns`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            table: tableName.trim(),
        }),
    });
    // 获得forbbiden_columns
    const forbbiden_columns = await response.json();

    // 动态生成新增数据输入框
    await $("#edit-fields").empty();
    // 获取所有列名的标签
    const headers = $("#data-table th label").toArray();
    for (const [index, element] of headers.entries()) {
        const columnName = $(element).text().trim();
        console.log(columnName);
        if (columnName === "操作" || forbbiden_columns.includes(columnName)) {
            continue;
        }

        // 检查是否为下拉框还是为输入框
        const isdropdown = await fetch(`${API_BASE}/api/get_dropdown`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                table: tableName.trim(),
                column: columnName,
            }),
        });
        const dropdown = await isdropdown.json();
        if (dropdown.ty === "dropdown"){
            const selectId = `select-${columnName}`;
            $("#edit-fields").append(`
            <label>${columnName}:</label>
            <select name="${columnName}" id="${selectId}" class="form-data">
            `);
            const selectElement = document.getElementById(selectId);
            dropdown.content.forEach((item) => {
                const option = document.createElement("option");
                option.value = item;
                option.textContent = item;
                if (item === rowData[columnName]) {
                    option.selected = true; // 设置被选择的值
                }
                selectElement.appendChild(option);
            });
        }else{
            // 如果是id的话给id上一个原本的id
            if(index === 0){
                $("#edit-fields").append(`
                <label>${columnName}:</label>
                <input type="text" name="${columnName}" id="input-${columnName}" value="${rowData[columnName]}" old="${rowData[columnName]}" class="form-data">
                `);
            }else{
                $("#edit-fields").append(`
                <label>${columnName}:</label>
                <input type="text" name="${columnName}" id="input-${columnName}" value="${rowData[columnName]}" class="form-data">
                `);
            }
        };
    };
    $("#edit-modal").show();
});

// 保存编辑
$("#save_edit").click(async function(){
    const formData = {};
    $("#edit-fields .form-data").each(function(){
        formData[$(this).attr("name")] = $(this).val();
    });
    const tableName = $("#table-select").val();
    const primaryKey = Object.keys(formData)[0];
    // 主键取第一个的old参数
    const primaryKeyValue = $(`#input-${primaryKey}`).attr("old");
    if (!tableName || !primaryKey || !primaryKeyValue) {
        alert("表名或主键信息缺失！");
        return;
    }
    const response = await fetch(`${API_BASE}/api/update_data`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            table: tableName.trim(),
            data: formData,
            primaryKey: primaryKey,
            primaryKeyValue: primaryKeyValue
        }),
    });

    const result = await response.json();
    if (response.status != 200){
        alert(`错误：${result.message}`);
        return;
    }
    $("#edit-modal").hide();
    $("#load-table").click();
});

// 取消编辑
$("#cancel_edit").click(function(){
    $("#edit-modal").hide();
})

// 点击删除按钮
$(document).on("click",".delete-btn",async function(){
    if(!confirm("确认删除该条数据吗？")) return;

    const tableName = $("#table-select").val();
    const primaryKey = $("#data-table th label:first").text();
    const primaryKeyValue = $(this).attr("data-row")
    const response = await fetch(`${API_BASE}/api/delete_data`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            table:tableName,
            primary_key:primaryKey,
            primary_key_value:primaryKeyValue
        }),
    });
    const result = await response.json();
    if (response.status != 200){
        alert(`错误：${result.message}`);
        return;
    }
    $("#load-table").click();
})

// 新增数据
$("#add-btn").click(async function(){
    const tableName = $("#table-select").val();
    if (!tableName) {
        alert("请选择表名！");
        return;
    }

    const response = await fetch(`${API_BASE}/api/forbbiden_columns`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            table: tableName.trim(),
        }),
    });
    // 获得forbbiden_columns
    const forbbiden_columns = await response.json();

    // 动态生成新增数据输入框——防止来不及消除
    await $("#add-fields").empty();

    const headers = $("#data-table th label").toArray();
    for (const header of headers) {
        const columnName = $(header).text().trim();
        if ((headers.indexOf(header) === 0 && tableName != "student_view") || columnName === "操作" || forbbiden_columns.includes(columnName)) {
            // 跳过 id 列，不需要新增数据
            continue;
        }
        // 检查是否为下拉框还是为输入框
        const isdropdown = await fetch(`${API_BASE}/api/get_dropdown`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                table: tableName.trim(),
                column: columnName,
            }),
        });
        const dropdown = await isdropdown.json();
        if (dropdown.ty === "dropdown"){
            const selectId = `select-${columnName}`;
            $("#add-fields").append(`
            <label>${columnName}:</label>
            <select name="${columnName}" id="${selectId}" class="form-data">
            `);
            let selectElement = document.getElementById(selectId);
            if (selectElement) {
            dropdown.content.forEach(function (item) {
                const option = document.createElement("option");
                option.value = item;
                option.textContent = item;
                selectElement.appendChild(option);
                });
            }
        }else{
            $("#add-fields").append(`
            <label>${columnName}:</label>
            <input type="text" name="${columnName}" id="input-${columnName}" class="form-data">
            `);
        };
    };
    $('#add-modal').show();
});

// 保存新增数据
$('#add-data').click(async function() {
    const formData = {};
    $("#add-fields .form-data").each(function(){
        const key = $(this).attr("name");
        const value = $(this).val();
        if (key) formData[key] = value;
    });
    const tableName = $("#table-select").val();
    // 验证是否有数据
    if (Object.keys(formData).length === 0){
        alert("请填写数据！");
        return;
    }
    const response = await fetch(`${API_BASE}/api/add_data`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            table: tableName.trim(),
            data: formData
        }),
    });
    const result = await response.json();
    if (response.status != 200){
        alert(`错误：${result.message}`);
        return;
    }
    $('#add-modal').hide();
    $("#load-table").click();
});

// 关闭添加弹窗
$("#add-close-btn").click(function() {
    $('#add-modal').hide();
});
// 关闭编辑弹窗
$("#edit-close-btn").click(function() {
    $('#edit-modal').hide();
});

// 动态更新下拉框数据
async function loadTableNames(){
    try{
        // 发起请求，返回的是表名的列表
        let response = await fetch(`${API_BASE}/api/get_tables`);
        const tableNames = await response.json();
        // 获取下拉框元素
        let selectElement = document.getElementById("table-select");
        // 清空现有的选项
        selectElement.innerHTML = "";

        // 将表名对象转换为数组，并按 name[2] 的顺序排序
        const sortedTableNames = Object.entries(tableNames).sort(
            ([, nameA], [, nameB]) => nameA[2] - nameB[2]
        );

        sortedTableNames.forEach(function([key,name]){
            console.log(key,name);
            let option = document.createElement("option");
            option.value = key;
            option.textContent = name[0];
            selectElement.appendChild(option);
        })
    }catch(error){
        console.error("无法加载表数据");
    }
    return;
}

// 监听下拉框的变化，更新表格数据
$("#table-select").change(function(){
    $("#load-table").click();
});

// 当页面加载时，就调用函数动态更新下拉框
window.onload = async function(){
    await loadTableNames();
    $("#load-table").click();
}