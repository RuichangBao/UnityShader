using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MVPTransform : MonoBehaviour
{
    public Camera mainCamera;
    private Material material;
    void Start()
    {
        mainCamera = Camera.main;
        material = this.GetComponent<Renderer>().material;
        ////将一个点从局部空间转换到世界空间的矩阵
        //Debug.LogError(transform.localToWorldMatrix.ToString());
        ////从世界转换到相机空间的矩阵
        //Debug.LogError(mainCamera.worldToCameraMatrix.ToString());
        ////设置自定义投影矩阵。
        //Debug.LogError(mainCamera.projectionMatrix);
    }

    // Update is called once per frame
    void Update()
    {
        float realtimeSinceStartup = Time.realtimeSinceStartup;
        //Debug.LogError(transform.localToWorldMatrix.ToString());
        //Debug.LogError(mainCamera.worldToCameraMatrix.ToString());
        //Debug.LogError(mainCamera.projectionMatrix);
        //Debug.LogError(realtimeSinceStartup);
        //mvp 模型->世界->摄像机->投影
        Matrix4x4 rm = new Matrix4x4();
        //绕y轴旋转
        //[Mathf.Cos,   0,  Mathf.Sin,  0
        // 0            1,  0,          0
        //-Mathf.Sin,   0,  Mathf.Cos,  0
        //0,            0,  0,          1
        rm[0, 0] = Mathf.Cos(realtimeSinceStartup);
        rm[0, 2] = Mathf.Sin(realtimeSinceStartup);
        rm[1, 1] = 1;
        rm[2, 0] = -Mathf.Sin(realtimeSinceStartup);
        rm[2, 2] = Mathf.Cos(realtimeSinceStartup);
        rm[3, 3] = 1;
        //rm[0, 0] = Mathf.Cos(realtimeSinceStartup);
        //rm[0, 1] = -Mathf.Sin(realtimeSinceStartup);
        //rm[1, 0] = Mathf.Sin(realtimeSinceStartup);
        //rm[1, 1] = Mathf.Cos(realtimeSinceStartup); 
        //rm[2, 2] = 1;
        //rm[3, 3] = 1;

        Matrix4x4 sm = new Matrix4x4();
        sm[0, 0] = Mathf.Sin(realtimeSinceStartup);
        sm[1, 1] = Mathf.Cos(realtimeSinceStartup);
        sm[2, 2] = Mathf.Sin(realtimeSinceStartup);
        sm[3, 3] = 1;
        Matrix4x4 mvp = mainCamera.projectionMatrix * mainCamera.worldToCameraMatrix * transform.localToWorldMatrix;
        material.SetMatrix("mvp", mvp * rm * sm);
        //material.SetMatrix("rm", rm);
    }
}