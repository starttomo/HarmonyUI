// server.js
const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

// 数据库连接配置
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'zhang728',
    database: 'ruoyi_db'
});

// 获取所有中药材列表（简要信息）
app.get('/api/herbs', (req, res) => {
    const { search = '', category = '' } = req.query;
    let sql = `SELECT h.herb_id, h.herb_name, h.category_id, c.category_name, h.image_url, h.views, h.likes, h.collections, h.indications
               FROM herb_info h
               LEFT JOIN herb_category c ON h.category_id = c.category_id`;
    const params = [];
    let whereArr = [];
    if (search) {
        whereArr.push('h.herb_name LIKE ?');
        params.push(`%${search}%`);
    }
    if (category && category !== 'all') {
        whereArr.push('c.category_name = ?');
        params.push(category);
    }
    if (whereArr.length > 0) {
        sql += ' WHERE ' + whereArr.join(' AND ');
    }
    sql += ' ORDER BY h.sort ASC, h.herb_id ASC LIMIT 100';
    db.query(sql, params, (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// 获取单个中药材详细信息
app.get('/api/herbs/:id', (req, res) => {
    const sql = `SELECT * FROM herb_info WHERE herb_id = ? `;
    db.query(sql, [req.params.id], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        if (results.length === 0) return res.status(404).json({ error: 'Not found' });
        res.json(results[0]);
    });
});

// 点赞/取消点赞
app.post('/api/herbs/:id/like', (req, res) => {
    const herbId = req.params.id;
    const { like } = req.body; // true=点赞，false=取消
    const sql = like
        ? 'UPDATE herb_info SET likes = likes + 1 WHERE herb_id = ?'
        : 'UPDATE herb_info SET likes = IF(likes > 0, likes - 1, 0) WHERE herb_id = ?';
    db.query(sql, [herbId], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ success: true });
    });
});

// 收藏/取消收藏
app.post('/api/herbs/:id/collect', (req, res) => {
    const herbId = req.params.id;
    const { collect } = req.body; // true=收藏，false=取消
    const sql = collect
        ? 'UPDATE herb_info SET collections = collections + 1 WHERE herb_id = ?'
        : 'UPDATE herb_info SET collections = IF(collections > 0, collections - 1, 0) WHERE herb_id = ?';
    db.query(sql, [herbId], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ success: true });
    });
});

// 获取所有分类
app.get('/api/categories', (req, res) => {
    db.query('SELECT category_id, category_name FROM herb_category WHERE status="1" ORDER BY sort ASC, category_id ASC', (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// 获取首页横幅药材（5条图片不为空的）
app.get('/api/herbs/banner', (req, res) => {
    db.query('SELECT herb_id, herb_name, image_url FROM herb_info WHERE image_url IS NOT NULL AND image_url != "" ORDER BY views DESC, herb_id ASC LIMIT 5', (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// 启动服务
const PORT = 8081;
app.listen(PORT,() => {
    console.log(`Server running at http://192.168.223.223:${PORT}`);
});

const CATEGORIES = [
    { name: '全部', value: 'all' },
    { name: '解表药', value: 1 },
    { name: '清热药', value: 2 },
    { name: '祛风湿药', value: 3 },
    { name: '补虚药', value: 4 },
];