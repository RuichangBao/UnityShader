using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MVPTransform2 : MonoBehaviour
{
    private Camera mainCamera;
    private Material material;
    private Matrix4x4 moveMatrix = new Matrix4x4();
    void Start()
    {
        mainCamera = Camera.main;
        material = this.GetComponent<Renderer>().material;
        moveMatrix[0, 0] = 1;
        
        moveMatrix[1, 1] = 1;
        moveMatrix[2, 2] = 1;
        moveMatrix[3, 3] = 1;
    }

    // Update is called once per frame
    void Update()
    {
        Matrix4x4 mvp = mainCamera.projectionMatrix * mainCamera.worldToCameraMatrix * transform.localToWorldMatrix;
        moveMatrix[0, 3] = Time.realtimeSinceStartup;
        material.SetMatrix("mvp", mvp * moveMatrix);
    }
}