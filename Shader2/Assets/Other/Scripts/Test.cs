
using UnityEngine;


public class Test : MonoBehaviour
{
    public RectTransform rect;
    void Start()
    {

    }
    public void TestFunc()
    {
        Quaternion quaternion = rect.transform.rotation;

        Vector3 vector3 = quaternion.eulerAngles;
        Debug.LogError(quaternion);
        Debug.LogError(vector3);
    }
}