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

// 登录接口
app.post('/api/login', (req, res) => {
    const { username, password } = req.body;
    if (!username || !password) {
        return res.status(400).json({ error: '用户名和密码不能为空' });
    }
    db.query('SELECT * FROM user_info WHERE username = ? AND password = ?', [username, password], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        if (results.length === 0) {
            return res.status(401).json({ error: '用户名或密码错误' });
        }
        // 登录成功，返回 token 或用户信息
        res.json({ token: 'mock-token', user: results[0] });
    });
});
// 获取所有中药材列表（简要信息）
app.get('/api/herbs', (req, res) => {
    const { search = '', category = '', user_id = 0 } = req.query;
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
        if (!user_id || user_id == 0) {
            return res.json(results);
        }
        const herbIds = results.map(r => r.herb_id);
        if (herbIds.length === 0) return res.json(results);
        // 修正IN查询参数展开
        const inSql = `SELECT target_id, action_type FROM user_interaction WHERE user_id = ? AND target_type = ? AND target_id IN (${herbIds.map(() => '?').join(',')})`;
        db.query(
            inSql,
            [user_id, 'herb', ...herbIds],
            (err2, userActs) => {
                if (err2) return res.status(500).json({ error: err2.message });
                results.forEach(item => {
                    item.liked = false;
                    item.collected = false;
                    userActs.forEach(act => {
                        if (act.target_id === item.herb_id && act.action_type === 'like') item.liked = true;
                        if (act.target_id === item.herb_id && act.action_type === 'collect') item.collected = true;
                    });
                });
                res.json(results);
            }
        );
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

// 点赞/取消点赞（带user_id）
app.post('/api/herbs/:id/like', (req, res) => {
    const herbId = req.params.id;
    const { user_id, like } = req.body;
    if (!user_id) return res.status(400).json({ error: '缺少user_id' });

    const updateHerbSql = like
        ? 'UPDATE herb_info SET likes = likes + 1 WHERE herb_id = ?'
        : 'UPDATE herb_info SET likes = IF(likes > 0, likes - 1, 0) WHERE herb_id = ?';

    const interactionSql = like
        ? 'INSERT INTO user_interaction (user_id, target_type, target_id, action_type, create_time) VALUES (?, ?, ?, ?, NOW())'
        : 'DELETE FROM user_interaction WHERE user_id = ? AND target_type = ? AND target_id = ? AND action_type = ?';

    db.query(updateHerbSql, [herbId], (err) => {
        if (err) return res.status(500).json({ error: err.message });
        if (like) {
            db.query(interactionSql, [user_id, 'herb', herbId, 'like'], (err2) => {
                if (err2) return res.status(500).json({ error: err2.message });
                res.json({ success: true });
            });
        } else {
            db.query(interactionSql, [user_id, 'herb', herbId, 'like'], (err2) => {
                if (err2) return res.status(500).json({ error: err2.message });
                res.json({ success: true });
            });
        }
    });
});

// 收藏/取消收藏（带user_id）
app.post('/api/herbs/:id/collect', (req, res) => {
    const herbId = req.params.id;
    const { user_id, collect } = req.body;
    if (!user_id) return res.status(400).json({ error: '缺少user_id' });

    const updateHerbSql = collect
        ? 'UPDATE herb_info SET collections = collections + 1 WHERE herb_id = ?'
        : 'UPDATE herb_info SET collections = IF(collections > 0, collections - 1, 0) WHERE herb_id = ?';

    const interactionSql = collect
        ? 'INSERT INTO user_interaction (user_id, target_type, target_id, action_type, create_time) VALUES (?, ?, ?, ?, NOW())'
        : 'DELETE FROM user_interaction WHERE user_id = ? AND target_type = ? AND target_id = ? AND action_type = ?';

    db.query(updateHerbSql, [herbId], (err) => {
        if (err) return res.status(500).json({ error: err.message });
        if (collect) {
            db.query(interactionSql, [user_id, 'herb', herbId, 'collect'], (err2) => {
                if (err2) return res.status(500).json({ error: err2.message });
                res.json({ success: true });
            });
        } else {
            db.query(interactionSql, [user_id, 'herb', herbId, 'collect'], (err2) => {
                if (err2) return res.status(500).json({ error: err2.message });
                res.json({ success: true });
            });
        }
    });
});

// 浏览量+1（带user_id）
app.post('/api/herbs/:id/view', (req, res) => {
    const herbId = req.params.id;
    const { user_id } = req.body;
    if (!user_id) return res.status(400).json({ error: '缺少user_id' });

    const updateHerbSql = 'UPDATE herb_info SET views = views + 1 WHERE herb_id = ?';
    const historySql = 'INSERT INTO user_history (user_id, target_type, target_id, create_time) VALUES (?, ?, ?, NOW())';

    db.query(updateHerbSql, [herbId], (err) => {
        if (err) return res.status(500).json({ error: err.message });
        db.query(historySql, [user_id, 'herb', herbId], (err2) => {
            if (err2) return res.status(500).json({ error: err2.message });
            res.json({ success: true });
        });
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

// 注册接口
app.post('/api/register', (req, res) => {
    const { username, password, phone, email, gender } = req.body;
    if (!username || !password) {
        return res.status(400).json({ error: '用户名和密码不能为空' });
    }
    db.query('SELECT * FROM user_info WHERE username = ?', [username], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        if (results.length > 0) {
            return res.status(409).json({ error: '用户已存在' });
        }
        const now = new Date();
        db.query(
            'INSERT INTO user_info (username, password, phone, email, gender, status, createTime, updateTime) VALUES (?, ?, ?, ?, ?, 1, ?, ?)',
            [username, password, phone, email, gender, now, now],
            (err2, result) => {
                if (err2) return res.status(500).json({ error: err2.message });
                res.json({ success: true });
            }
        );
    });
});

// 获取用户点赞的中药
app.get('/api/user/:userId/likes', (req, res) => {
    const userId = req.params.userId;
    const sql = `
      SELECT h.herb_id, h.herb_name, h.image_url, i.create_time
      FROM user_interaction i
      JOIN herb_info h ON i.target_id = h.herb_id
      WHERE i.user_id = ? AND i.target_type = 'herb' AND i.action_type = 'like'
      ORDER BY i.create_time DESC
    `;
    db.query(sql, [userId], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// 获取用户收藏的中药
app.get('/api/user/:userId/collections', (req, res) => {
    const userId = req.params.userId;
    const sql = `
      SELECT h.herb_id, h.herb_name, h.image_url, i.create_time
      FROM user_interaction i
      JOIN herb_info h ON i.target_id = h.herb_id
      WHERE i.user_id = ? AND i.target_type = 'herb' AND i.action_type = 'collect'
      ORDER BY i.create_time DESC
    `;
    db.query(sql, [userId], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// 启动服务
const PORT = 8081;
app.listen(PORT,() => {
    console.log(`Server running at http://192.168.223.223:${PORT}`);
});
