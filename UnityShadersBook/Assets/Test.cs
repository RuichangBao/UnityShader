using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Test : MonoBehaviour
{
    void Start()
    {
        Matrix4x4 frustumCorners = Matrix4x4.identity;
        Debug.LogError(frustumCorners.ToString());
    }

    void Update()
    {
        Debug.LogError(this.transform.right);
    }
}
