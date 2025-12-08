import numpy as np

MAX_X = 1226
MAX_Y = 370
EPS = 1

cube_edges = [
    (0,1), (2,3), (4,5), (6,7),
    (0,2), (1,3), (4,6), (5,7),
    (0,4), (1,5), (2,6), (3,7)
]


def is_on_segment(px, py, ax, ay, bx, by):
    cross = (px-ax) * (py-by) - (px-bx) * (py-ay)
    return (-EPS < cross and cross < EPS) and \
           ((ax <= px and px <= bx) or (bx <= px and px <= ax)) and \
           ((ay <= py and py <= by) or (by <= py and py <= ay))

sig_out_exp = []
pixels = np.zeros(MAX_X*MAX_Y, dtype=np.uint32)

class CubeModel:

    state = "INPUT_CUBE"
    cube_pts = []
    cur_point = 0
    cur_x = 0
    cur_y = 0

    def cube_model0(cls, val):
        val, last = val
        if cls.state == "INPUT_CUBE":
            x = val & 0x7FF
            y = (val >> 11) & 0x7FF
            cls.cube_pts.append((x,y))
            if cls.cur_point == 7:
                assert last == 1
                cls.state = "STREAM_FRAME"
                cls.cur_point = 0
            else:
                cls.cur_point += 1

    def cube_model1(cls, val):
        val, last = val
        if cls.state == "STREAM_FRAME":
            pixel = val
            for i,j in cube_edges:
                if is_on_segment(cls.cur_x, cls.cur_y, cls.cube_pts[i][0], cls.cube_pts[i][1], cls.cube_pts[j][0], cls.cube_pts[j][1]):
                    pixel = 0xFF0000
            sig_out_exp.append((pixel, last))
            pixels[cls.cur_y*MAX_X+cls.cur_x] = pixel
            if cls.cur_x == MAX_X-1:
                if cls.cur_y == MAX_Y-1:
                    assert last == 1
                    cls.cur_y = 0
                    cls.cube_pts.clear()
                    cls.state = "INPUT_CUBE"
                else:
                    cls.cur_y += 1
                cls.cur_x = 0
            else:
                cls.cur_x += 1
    




